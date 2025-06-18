import os
import pandas as pd
import pprint
import inspect
import logging
import time
import sys
from functools import wraps
from contextlib import contextmanager
import os
import psutil

DEBUG_MODE=False
_logger = None
EXCLUDE_FROM_DEBUG_CALL = {"debug_log","enable_debug","get_logger"}

def head(filepath, num_lines=5):
    """Prints first 'num_lines' lines of a file."""
    if not os.path.exists(filepath):
        print(f"\n[DEBUG] File not found: {filepath}")
        return
    print(f"\n[DEBUG] First {num_lines} lines of {filepath}")
    with open(filepath,'r') as f:
        for i, line in enumerate(f):
            if i>=num_lines:
                break
            print(line.strip())
            
def df_info(df, name='DataFrame'):
    """Prints basic info about a pandas DataFrame."""
    print(f"\n[DEBUG] {name} shape: {df.shape}")
    print(f"[DEBUG] {name} Columns:")
    print(list(df.columns)
    print(f"[DEBUG] First few rows of {name}:")
    print(df.head())

def print_var(var, name='Variable', max_len=1000):
    """Prints variable with optional truncation."""
    print(f"\n[DEBUG] {name}:")
    s = pprint.pformat(var)
    if len(s) > max_len:
        print(s[:max_len] + "... [truncated]")
    else:
        print(s)
        
def print_call_location():
    """Prints location in code where this function is called."""
    frame = inspect.currentframe().f_back
    filename = frame.f_code.co_filename
    lineno = frame.f_lineno
    print(f"\n[DEBUG] Called from {filename}:{lineno}")
    
def pwd():
    """Prints working directory"""
    print(os.get_cwd())
    
def print_dict_keys(d, name='Dict'):
    """Prints top level keys of dictionary."""
    if not isinstance(d, dict):
        print(f"[DEBUG] {name} is not a dict.")
        return
    print(f"\n[DEBUG] Keys in {name}: {list(d.keys())}")
    
def _get_caller_script():
    """Get name of calling script"""
    frame=inspect.stack()[-1]
    filename=os.path.basename(frame.filename)
    return os.path.splittext(filename)[0]
    
def enable_debug(name=None, level=logging.DEBUG):
    """
    Enable debug mode and automatically set up logger.
    If no name is given, uses name of calling script.
    """
    global DEBUG_MODE, get_logger
    DEBUG_MODE=True
    script_name = name or _get_caller_script()
    _logger = get_logger(script_name, level)
    _logger.info("[DEBUG] Debug mode enabled from {script_name}.")
    
def get_logger(name='debug_logger', level=logging.DEBUG):
    """
    Returns a configured logger instance.
    
    Params:
        - name (str): Name of the logger
        - level (logging level): DEBUG, INFO, WARNING, etc.
        
    Returns:
        - logger (logging.logger): Configured logger.
    """
    logger=logging.getLogger(name)
    if not logger.handlers:
        handler=logging.StreamHandler()
        formatter=logging.Formatter('[%(levelname)s] %(asctime)s', datefmt='%H:%M:%S')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
        logger.setLevel(level)
    return logger
    
def debug_log(message):
    """Logs or prints a message depending on debug mode."""
    if DEBUG_MODE and _logger:
        _logger.debug(message)
    elif DEBUG_MODE:
        print(f"[DEBUG] {message}")
      
def debug_memory_snapshot(label="Current"):
    if DEBUG_MODE:
        mem = current_memory_usage_mb()
        debug_log(f"{label} memory usage: {mem.2f} MB")
        
def print_memory_usage(label="Memory"):
    """Prints current memory usage {requires psutil)."""
    if DEBUG_MODE:
        process=psutil.Process(os.getpid())
        mem=process.memory_info().rss / 1024 / 1024
        debug_log(f"{label} memory usage: {mem:.2f} MB")
        
def current_memory_usage_mb():
    """Returns current memory usage of the process in megabytes"""
    process=psutil.Process(os.getpid())
    mem_bytes = process.memory_info().rss
    return mem_bytes/ 1024 / 1024
    
def estimate_object_size(obj, label='Object'):
    """
    Estimates the memory size of an object in MB.
    
    Parameters:
        - obj: The Python object to estimate.
        - label: Optional label to include in output.
    
    Returns:
        - float: Estimated size in MB.
    """
    size_bytes=sys.getsizeof(obj)
    size_mb = size_bytes / 1024 / 1024
    print(f"[DEBUG] {label} estimated size: {size_mb.4f} MB")
    return size_mb
    
def track_memory(func):
    """Decorator to track mem usage before and after function"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        mem_before=current_memory_usage_mb()
        result=func(*args, **kwargs)
        mem_after=current_memory_usage_mb()
        print(f"[DEBUG]{func.__name__} memory: {mem_before:.f} → {mem_after:.2f} MB")
        print(f"(Δ {mem_after - mem_before:.2f} MB)")
        return result
    return wrapper

def log_function_call(func):
    """Wraps function arguments and return value when in debug mode."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        if DEBUG_MODE:
            debug_log(f"Calling {func.__name__} with args={args}, kwargs={kwargs}")
        result=func(*args, **kwargs)
        if DEBUG_MODE:
            debug_log(f"{func.__name__} returned {result}")
        return result
    return wrapper
    
def debug_only(func):
    """Decorator to run a function only when debugging is enabled."""
    @wraps(func)
    def wrapper(*args, **kwargs):
        if DEBUG_MODE:
            return func(*args, **kwargs)
    return wrapper
    
def timeit(func):
    """
    Decorator to measure execution time of a function
    
    Usage:
        @timeit
        def your_function():
        ...
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        print(f"[DEBUG] Timing function: {func.__name__}")
        start_time=time.time()
        result=func(*args, **kwargs)
        end_time=time.time()
        duration=end_time-start_time
        print(f"[DEBUG] {func.__name__} executed un {duration:.4f} seconds")
        return result
    return wrapper
    
def timeit_debug(func):
    """Decorator to time functions when debugging is enabled."""
    @wraps(func)
    def wrapper(*arfs, **kwargs):
        if DEBUG_MODE:
            debug_log(f"Timing function: {func.__name__}")
            start_time=time.time()
            result=func(*args, **kwargs)
            end_time=time.time()
            duration=end_time-start_time
            print(f"[DEBUG] {func.__name__} executed un {duration:.4f} seconds")
            return result
        else:
            return func(*args, **kwargs)
        return wrapper
    
@contextmanager
def timer(name='Block'):
    """
    Context manager to time a block of code.
    
    Usage:
        with timer("Loading data"):
            do_something()
    """
    start=time.time()
    yield
    end=time.time()
    print(f"[DEBUG] {name} took {end-start:.4f} seconds")
    
@debug_only
def estimate_and_log_object_size(obj, label='Object'):
    size=estimate_object_size(obj, label)
    debug_log(f"{label} estimated object size: {size:.4f}MB")




def debug_call(func_name, *args, *kwargs):
    """
    Dynamically calls a function from debug.utils and logs result.
    
    Params:
        - func_name (str): Name of function to call.
        - *args, **kwargs: Arguments to pass to function.
    
    Returns:
        - Any: Return value of the function.
    """
    if not DEBUG_MODE:
        return
    this_module=sys.modules[__name__]
    func=getattr(this_module, func_name, None)
    
    if func is None or not callable(func):
        debug_log(f"[DEBUG_CALL] '{func_name}' not found or not callable.")
        return None
    
    try:
        result=func(*args, **kwargs)
        if func_name not in EXCLUDE_FROM_DEBUG_CALL:
            debug_log(f"[DEBUG_CALL] {func_name}() returned: {repr(result)}")
        return result
    except Exception as e:
        debug_log(f"[DEBUG_CALL] Error calling {func_name}: {e}")
        return None
