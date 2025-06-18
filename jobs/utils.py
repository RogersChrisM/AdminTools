import subprocess
import os
from debug.utils import info,error

def run_remote_exec(command: str, remote_host: str = 'crogers@hpc.stjude.org', key=True, use_logger=False, logger=None):
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
    log = logger.info if use_logger else print
    error = logger.error if use_logger else print
    current_dir = os.path.dirname(os.path.abspath(__file__))  # dir of this .py file
    script_path = os.path.join(current_dir, 'remote_exec.sh')
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

# Example usage #
#run_remote("module load deepTools")
    
def transfer(files, remote_host: str ='crogers@hpc.stjude.org' , remote_path: str ='~/remote', key=True, direction:str='upload', use_logger=False, logger=None):
    """
    Upload or download a list of local files to a remote host using SCP.

    Args:
        files (str or list of str): File(s) to transfer. Ensure each is a string of the absolute path.
        remote_host (str): Remote host (e.g. 'user@host').
        remote_path (str): Remote directory path.
        key (bool or str): Use default key (True), no key (False), or custom path (str).
        direction (str): 'upload' (local → remote) or 'download' (remote → local).
        use_logger (bool): Whether to log output using a logger.
        logger: A configured logging.Logger instance.
    """
    if use_logger and logger is None:
        raise ValueError("Logger object must be provided if use_logger=True")
    log = logger.info if use_logger else print
    error = logger.error if use_logger else print
    if isinstance(files,str):
        files=[files]
    elif not isinstance(files(list,tuple)):
        raise ValueError("`files` must be a string or a list/tuple of strings")
    remote_path=os.expanduser(remote_path)
    for file in files:
        if direction=='upload':
            if not os.path.exists(file):
                raise FileNotFoundError(f"[ERROR] Local file does not exist: {file}")
            local_path=file
            target_path=f'{remote_host}:{remote_path}/'
        elif direction=='download':
            local_path='.'
            target_path = f'{remote_host}:{file}'
        else:
            raise ValueError("`direction` must be 'upload' or 'download'.")
        if key:
            KEY=os.path.expanduser('~/.ssh/id_rsa')
            args=['scp', '-i', KEY]
        else:
            args=['scp']
            
        if direction=='upload':
            args+=[local_path,target_path]
            log(f"[INFO] Uploading {file} to {remote_host}:{remote_path}")
        else:
            args+=[target_path,local_path]
            log(f"[INFO] Downloading {file} from {remote_host} to current directory")
        try:
            subprocess.run(args,check=True)
            print(f"[INFO] file upload successful: {file}")
        except subprocess.CalledProcessError as e:
            print(f"[ERROR]: Unable to upload: {file}:\n{e}")
            raise

def transfer_from

# Example usage #
#transfer("data/file.txt")
#transfer(["data/file1.txt","data/file2.txt"], remote_path="~/scratch")


    
if __name__=='__main__':
    print("Not for standalone use.")
    exit(1)
