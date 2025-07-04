function kcv --wraps='kubectl config current-context' --description 'alias kcv=kubectl config current-context'
    set -l ctx (kubectl config current-context)

    kubectl config get-contexts $ctx
end
