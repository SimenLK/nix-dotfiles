# name: Sorin
# author: Leonard Hecker <leonard@hecker.io>

# Sources:
# - General theme setup: https://github.com/sorin-ionescu/prezto/blob/d275f316ffdd0bbd075afbff677c3e00791fba16/modules/prompt/functions/prompt_sorin_setup
# - Extraction of git info: https://github.com/sorin-ionescu/prezto/blob/d275f316ffdd0bbd075afbff677c3e00791fba16/modules/git/functions/git-info#L180-L441

function k8s_ctx_and_namespace
    command kubectl config get-contexts | grep '^*' | awk '{printf "(%s/%s)", $2, $5}'
end

function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color blue)(prompt_pwd)' '

    if test -n "$IN_NIX_SHELL"
        echo -n (set_color red)"[nix-shell] "
    end

    set -l cmd_status $status
    if test $cmd_status -ne 0
        echo -n (set_color red)"✘ $cmd_status "
    end

    set_color -o
    if test "$USER" = 'root'
        echo -n (set_color red)'# '
    else
        echo -n (set_color green)'λ '
    end
    set_color normal
end
