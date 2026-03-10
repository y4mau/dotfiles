# Real-time clock in YYYY-MM-DD format

function clock
    while true
        tput civis
        printf "\r"(env LC_TIME=en_US.UTF-8 date '+%Y-%m-%d %H:%M:%S %a %Z')
        sleep 1
    end
    tput cnorm
    printf "\n"
end
