function kcv --wraps='kubectl config current-context' --description 'alias kcv=kubectl config current-context'
    kubectl config current-context;
end
