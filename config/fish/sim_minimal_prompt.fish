function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color blue)(basename $PWD)' '

    set_color -o
    if test "$USER" = 'root'
        echo -n (set_color red)'# '
    else
        echo -n (set_color green)'λ '
    end
    set_color normal
end
