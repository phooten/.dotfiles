#!/usr/bin/env bash

set -u

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
SCRIPT_PATH="$ROOT_DIR/dotfiles.sh"

run_script() {
    local tmp_home="$1"
    shift

    env -i \
        HOME="$tmp_home" \
        PATH="$PATH" \
        TERM="${TERM:-xterm}" \
        DOTFILES="$ROOT_DIR" \
        bash "$SCRIPT_PATH" "$@"
}

assert_file_exists() {
    local path="$1"

    if [[ ! -e "$path" ]]; then
        echo "FAIL: expected file or symlink at $path"
        return 1
    fi
}

test_help() {
    local tmp_home
    tmp_home=$(mktemp -d)

    local output
    output=$(run_script "$tmp_home" --help 2>&1)
    local status=$?

    if [[ $status -ne 0 ]]; then
        echo "FAIL: help exited with status $status"
        echo "$output"
        return 1
    fi

    if ! grep -q "Usage:" <<<"$output"; then
        echo "FAIL: help output did not include usage text"
        echo "$output"
        return 1
    fi

    rm -rf "$tmp_home"
}

test_rejects_conflicting_actions() {
    local tmp_home
    tmp_home=$(mktemp -d)

    local output
    output=$(run_script "$tmp_home" --install --uninstall 2>&1)
    local status=$?

    if [[ $status -ne 1 ]]; then
        echo "FAIL: conflicting actions should exit 1, got $status"
        echo "$output"
        rm -rf "$tmp_home"
        return 1
    fi

    if ! grep -qi "only one action flag may be used at a time" <<<"$output"; then
        echo "FAIL: conflicting action message missing"
        echo "$output"
        rm -rf "$tmp_home"
        return 1
    fi

    rm -rf "$tmp_home"
}

test_verbose_install_output() {
    local tmp_home
    tmp_home=$(mktemp -d)

    local output
    output=$(run_script "$tmp_home" --verbose --install 2>&1)
    local status=$?

    if [[ $status -ne 0 ]]; then
        echo "FAIL: verbose install exited with status $status"
        echo "$output"
        rm -rf "$tmp_home"
        return 1
    fi

    if ! grep -q "ACTION: install" <<<"$output"; then
        echo "FAIL: verbose output missing install action details"
        echo "$output"
        rm -rf "$tmp_home"
        return 1
    fi

    rm -rf "$tmp_home"
}

test_install_creates_symlinks() {
    local tmp_home
    tmp_home=$(mktemp -d)

    run_script "$tmp_home" --install >/dev/null 2>&1
    local status=$?

    if [[ $status -ne 0 ]]; then
        echo "FAIL: install exited with status $status"
        return 1
    fi

    if [[ ! -L "$tmp_home/.bashrc" ]]; then
        echo "FAIL: expected symlink for .bashrc was not created"
        ls -la "$tmp_home"
        rm -rf "$tmp_home"
        return 1
    fi

    assert_file_exists "$tmp_home/.bashrc"

    rm -rf "$tmp_home"
}

test_uninstall_removes_symlinks() {
    local tmp_home
    tmp_home=$(mktemp -d)

    run_script "$tmp_home" --install >/dev/null 2>&1
    run_script "$tmp_home" --uninstall >/dev/null 2>&1
    local status=$?

    if [[ $status -ne 0 ]]; then
        echo "FAIL: uninstall exited with status $status"
        return 1
    fi

    if [[ -e "$tmp_home/.bashrc" ]]; then
        echo "FAIL: expected .bashrc to be removed after uninstall"
        ls -la "$tmp_home"
        rm -rf "$tmp_home"
        return 1
    fi

    rm -rf "$tmp_home"
}

run_test() {
    local test_name="$1"

    echo "Running $test_name"
    if "$test_name"; then
        echo "PASS: $test_name"
    else
        echo "FAIL: $test_name"
        exit 1
    fi
}

run_test test_help
run_test test_rejects_conflicting_actions
run_test test_verbose_install_output
run_test test_install_creates_symlinks
run_test test_uninstall_removes_symlinks

echo "All dotfiles tests passed."
