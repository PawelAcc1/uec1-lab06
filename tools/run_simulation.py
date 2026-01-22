#!/usr/bin/env python3

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT_DIR = Path(os.environ["ROOT_DIR"])
SIM_BUILD_DIR = Path(os.environ["SIM_BUILD_DIR"])

def execute_command(cmd, **kwargs):
    print(f"\n=> Executing command:")
    print("    " + " ".join(cmd))
    subprocess.run(cmd, **kwargs)

def run_simulation(args):
    test_name = args.testname
    gui_mode = args.g

    print(f"===== Running simulation for test: {test_name} =====")

    print(f"\n=> Preparing clean build dir: {SIM_BUILD_DIR}")
    shutil.rmtree(SIM_BUILD_DIR, ignore_errors=True)
    SIM_BUILD_DIR.mkdir(parents=True, exist_ok=True)

    XELAB_OPTS=[
        f"work.{test_name}_test",
        "-snapshot",
        f"{test_name}_test",
        "-prj",
        str(ROOT_DIR / "sim" / test_name / f"{test_name}.prj"),
    ]

    if gui_mode:
        execute_command([
            "xelab",
            *XELAB_OPTS,
            "-debug",
            "typical"
        ], check=True, cwd=SIM_BUILD_DIR)
        execute_command([
            "xsim",
            f"{test_name}_test",
            "-gui",
            "-t",
            str(ROOT_DIR / "sim" / test_name / "commands.tcl")
        ], check=True, cwd=SIM_BUILD_DIR)
    else:
        execute_command([
            "xelab",
            *XELAB_OPTS,
            "-standalone",
            "-runall"
        ], check=True, cwd=SIM_BUILD_DIR)

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-g",
        action="store_true",
        help="Run xsim in GUI mode",
    )
    parser.add_argument(
        "testname",
        help="Name of the test to run",
    )
    return parser.parse_args()

def main():
    args = parse_args()
    try:
        run_simulation(args)
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
