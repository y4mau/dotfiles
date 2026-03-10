# Lazy load Google Cloud SDK

function gcloud --wraps gcloud
    set -l sdk_path ""

    if test "$IS_MACOS" = true
        for p in $HOME/Downloads/google-cloud-sdk $HOME/google-cloud-sdk /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk
            if test -d $p
                set sdk_path $p
                break
            end
        end
    else
        set sdk_path $HOME/google-cloud-sdk
    end

    if test -n "$sdk_path"
        test -f "$sdk_path/path.fish.inc"; and source "$sdk_path/path.fish.inc"
        test -f "$sdk_path/completion.fish.inc"; and source "$sdk_path/completion.fish.inc"
    end

    functions -e gcloud
    gcloud $argv
end
