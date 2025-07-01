import subprocess
import os
import tempfile
from utils.utils import get_loggers


def run_remote(command: str, remote_host: str = 'crogers@hpc.stjude.org', key=True, use_logger=False, logger=None):
    """
    Call the remote_exec.sh bash script from Python with given remote and command.
    
    Args:
        command (str or group of strings): Commands to execute (see example)
        remote_host (str): user@hostsite
        key (bool): if using key. Make sure key is in '~/.ssh/id_rsa'
        use_logger (bool): Whether to log output using a logger.
        logger: A configured logging.Logger instance.
    
    Examples: Commands are acceptable in the following ways
        "cp path/to/remote/file path/to/remote/destination"
        or
        ("module load deeptools &&"
        "plotHeatmap -m matrix.gz -out heatmap.png")
        Recommended: if using the second option, save to a 'command' var prior to passing.
    """
    log, error=get_loggers(use_logger,logger)
    current_dir=os.path.dirname(os.path.abspath(__file__))  # dir of this .py file
    script_path=os.path.join(current_dir, 'remote_exec.sh')
    if key:
        KEY=os.path.expanduser('~/.ssh/id_rsa')
        args=[script_path, remote_host, command, '-k', KEY]
    else:
        args=[script_path, remote_host, command]
    try:
        result=subprocess.run(args, capture_output=True, check=True, text=True)
        log("[INFO]: Remote Job successful")
        return result.stdout
    except subprocess.CalledProcessError as e:
        error(f"[ERROR] Remote job failed:\n{e.stderr}")
        raise
    
def transfer(files, remote_host: str ='crogers@hpc.stjude.org' , remote_path: str ='/home/crogers/remote', key=True, direction:str='upload', local_path=None, use_logger=False, logger=None):
    """
    Upload or download a list of local files to a remote host using SCP. [NOTE]: if downloading, all files are assumed to be in remote_path!

    Args:
        files (str or list of str): File(s) to transfer. Ensure each is a string of the absolute path.
        remote_host (str): Remote host (e.g. 'user@host').
        remote_path (str): Remote directory path.
        key (bool or str): Use default key (True), no key (False), or custom path (str).
        direction (str): 'upload' (local → remote) or 'download' (remote → local).
        use_logger (bool): Whether to log output using a logger.
        logger: A configured logging.Logger instance.
    """
    log, error=get_loggers(use_logger,logger)
    if isinstance(files, str):
        files=[files]
    elif not isinstance(files, (list, tuple)):
        raise ValueError("`files` must be a string or a list/tuple of strings")
    if direction=='upload':
        for f in files:
            if not os.path.exists(f):
                raise FileNotFoundError(f"[ERROR] Local file does not exist: {f}")
        if key:
            KEY=os.path.expanduser('~/.ssh/id_rsa')
            args=['scp', '-i', KEY]
        else:
            args=['scp']
        args.extend(files)
        args.append(f'{remote_host}:{remote_path}/')
        log(f"[INFO] Uploading {len(files)} files to {remote_host}:{remote_path}")
    elif direction=='download':
        # All files assumed to be in remote_path; download all in one SCP call
        remote_files=[f"{remote_host}:{remote_path}/{file}" for file in files]
        if local_path is None:
            local_path='.'
        args=base_args + remote_files + [local_path]
        log(f"[INFO] Downloading {len(files)} files from {remote_host}:{remote_path} to current directory")
        try:
            subprocess.run(args, check=True)
            log(f"[INFO] File download successful: {files}")
        except subprocess.CalledProcessError as e:
            error(f"[ERROR]: Unable to download files {files}:\n{e}")
            raise
    else:
        raise ValueError("`direction` must be 'upload' or 'download'.")
    try:
        subprocess.run(args, check=True)
        log(f"[INFO] file transfer successful")
    except subprocess.CalledProcessError as e:
        error(f"[ERROR]: Unable to transfer files:\n{e}")
        raise


def run_temp_input(inputs=None, command_args=None, keep_temp=False, use_logger=False, logger=None):
    """
    Run a subprocess command optionally writing inputs to a temp file.

    Args:
        inputs (str or list of str, optional): Lines to write to a temp input file.
            If None, no temp file is created.
        command_args (list of str): Full list of command and arguments to run,
            e.g. ['python3', 'script.py', '-i', '<tempfile>'].
            Use '<tempfile>' as a placeholder where the temp filename should be inserted!
        keep_temp (bool): If True, do NOT delete the temp input file after running.
        use_logger (bool): If True, use logger.info for output.
        logger (logging.Logger): Logger instance to use if use_logger is True.

    Returns:
        subprocess.CompletedProcess: The result from subprocess.run()

    Raises:
        ValueError: if command_args missing or invalid, or logger missing if use_logger=True.
        TypeError: if inputs type invalid.
        FileNotFoundError: if script not found.
    """
    if not command_args or not isinstance(command_args, (list, tuple)):
        raise ValueError("`command_args` must be a non-empty list or tuple of strings.")
    log, error=get_loggers(use_logger,logger)
    if inputs is not None:
        if isinstance(inputs, str):
            input_lines=[inputs]
        elif isinstance(inputs, (list, tuple)):
            input_lines=list(inputs)
        else:
            raise TypeError("[ERROR] `inputs` must be a string or a list/tuple of strings.")

        with tempfile.NamedTemporaryFile(mode='w+', suffix='.txt', delete=False) as tmp:
            for line in input_lines:
                tmp.write(line.strip() + '\n')
            tmp_path=tmp.name
            log(f"[INFO] Temporary input file created at: {tmp_path}")
    else:
        tmp_path=None
    cmd=[]
    for arg in command_args:
        if arg=='<tempfile>':
            if tmp_path is None:
                raise ValueError("[ERROR] Command includes '<tempfile>' but no inputs were provided.")
            cmd.append(tmp_path)
        else:
            cmd.append(arg)
    log(f"[INFO] Running command: {' '.join(cmd)}")
    try:
        result=subprocess.run(cmd, check=True, capture_output=True, text=True)
        log(f"[INFO] Command finished successfully with return code {result.returncode}")
        if result.stdout:
            log(f"STDOUT:\n{result.stdout.strip()}")
        if result.stderr:
            log(f"STDERR:\n{result.stderr.strip()}")
    except subprocess.CalledProcessError as e:
        log(f"[INFO] Command failed with return code {e.returncode}")
        if e.stdout:
            log(f"STDOUT:\n{e.stdout.strip()}")
        if e.stderr:
            log(f"STDERR:\n{e.stderr.strip()}")
        raise
    finally:
        if tmp_path and not keep_temp:
            try:
                os.remove(tmp_path)
                log(f"[INFO] Temporary input file deleted: {tmp_path}")
            except Exception as e:
                log(f"[INFO] Failed to delete temp file {tmp_path}: {e}")
    return result
    

def waitForProcess(pids, script_path='~/Desktop/python_scripts/admin_tools/jobs/waitForProcess.sh', use_logger=False, logger=None):
    """
    Waits for one or more processes to complete using a waitForProcess.sh.
    
    Params:
        pids (int, str, list, or tuple): One or more process IDs to wait for.
        script_path (str): Path to the shell script waitForProcess.sh within admin_tools package.
    """
    script_path=os.path.expanduser(script_path)
    log, error=get_loggers(use_logger,logger)
    if isinstance(pids, (int,str)):
        pids=[pids]
    for pid in pids:
        try:
            completed_process=subprocess.run([script_path, str(pid)], check=True, text=True, capture_output=True)
            if completed_process.stderr:
                error("ERRORS ENCOUNTERED:", completed_process.stderr)
            else:
                print(f"[PID {pid}] Completed successfully.")
        except subprocess.CalledProcessError as e:
            error(f"An error occured while monitoring PID {pid}: {e}")

    
if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
