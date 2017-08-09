#!/bin/bash

[[ $# -ne 1 ]] && [[ $# -ne 2 ]] && die "Usage: $PROGRAM $COMMAND [--clip,-c] pass-name"

if [[ $1 = "-c" ]] || [[ $1 = "--clip"  ]]; then
    local clip=1
    local path="$2"
elif [[ $2 = "-c" ]] || [[ $2 = "--clip"  ]]; then
    local clip=1
    local path="$1"
else
    local clip=0
    local path="$1"
fi

local passfile="$PREFIX/$path.gpg"
check_sneaky_paths "$path"
set_gpg_recipients "$(dirname "$path")"
set_git $passfile

if [[ -f $passfile ]]; then
    local file_contents=`$GPG -d "${GPG_OPTS[@]}" "$passfile"`

    local header=`echo "$file_contents" | head -n 1`
    if [[ "$header" != "# pass-botp" ]]; then
        die "Error: $passfile needs pass-botp header '# pass-botp'"
    fi

    local backup_code=`echo "$file_contents" | grep -m 1 "^[^#;]"`

    if [[ -z "$backup_code" ]]; then
        die "Unable to get backup code"
    fi 
    
    local updated_file_contents=`sed "s/$backup_code/# $backup_code/" <<< $file_contents`
    
    if [[ $clip -eq 0 ]]; then
        echo $backup_code
    else
        clip "$backup_code" "Backup code for $path"
    fi
    $GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o "$passfile" "${GPG_OPTS[@]}" <<< "$updated_file_contents"

    git_add_file "$passfile" "Used backup code for $path."
elif [[ -z $path ]]; then
    die ""
else
    die "Error: $path is not in the password store."
fi
