if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Handy aliases
alias ll='ls -lh --color=auto'
alias gs='git status'
alias ports='nmap -p- 127.0.0.1'
alias prog2='cd ~/prog2'
alias prog='cd ~/Dropbox/prog'
alias web='cd ~/Dropbox/prog/web'
alias doc="cd ~/Dropbox/documents/various"
alias vim="~/Downloads/temp/vim/src/vim"
alias downloads='cd ~/Downloads/'
alias home='cd ~'
alias nvim='/home/jonas/Downloads/temp/nvim-linux-x86_64/bin/nvim'
alias fz='/usr/bin/fzf'
alias ms='~/Downloads/temp/mitos/target/release/ms'
alias zed='~/Downloads/temp/zed.app/bin/zed'

function nvimin
    env NVIM_APPNAME=nvimin /home/jonas/Downloads/temp/nvim-linux-x86_64/bin/nvim $argv
end

function nvim_native
    env NVIM_APPNAME=nvim_native /home/jonas/Downloads/temp/nvim-linux-x86_64/bin/nvim $argv
end

function procgrep

    set query $argv

    if test (count $query) -eq 0
        set query ".*"
    end
    ps -eo pid,%cpu,rss,comm,args | awk -v q="$query" '

	BEGIN {
    		printf "%-8s %-8s %-10s %s\n", "PID", "CPU%", "RSS(MB)", "COMMAND"
	}

	{
    		line = $0

    	if (line ~ q) {
        	printf "%-8s %-8.1f %-10.1f %s\n",
               		$1, $2, $3/1024, $4

        cpu += $2
        rss += $3
        count++
    	}
}

	END {
    		printf "\nProcesses: %d\n", count
    		printf "Total CPU: %.1f%%\n", cpu
    		printf "Total Memory: %.1f MB\n", rss/1024
	}
       '
end

function memgrep
    if test (count $argv) -eq 0
        ps -eo pid,rss,vsz,comm | \
        awk '
            function fmt(kb) {
                mb = kb / 1024
                if (mb >= 1024)
                    return sprintf("%.2f GB", mb / 1024)
                else
                    return sprintf("%.1f MB", mb)
            }

            BEGIN {
                printf "%-8s %-12s %-12s %s\n",
                       "PID", "RSS", "VSZ", "COMMAND"
            }

            NR > 1 {
                rss += $2
                vsz += $3

                printf "%-8s %-12s %-12s %s\n",
                       $1, fmt($2), fmt($3), $4
            }

            END {
                printf "\nTotal RSS: %s\n", fmt(rss)
                printf "Total VSZ: %s\n", fmt(vsz)
            }
        '
    else
        set pids (pgrep $argv)

        if test (count $pids) -eq 0
            echo "No processes found matching '$argv'"
            return 1
        end

        ps -o pid,rss,vsz,comm -p (string join "," $pids) | \
        awk '
            function fmt(kb) {
                mb = kb / 1024
                if (mb >= 1024)
                    return sprintf("%.2f GB", mb / 1024)
                else
                    return sprintf("%.1f MB", mb)
            }

            NR == 1 {
                printf "%-8s %-12s %-12s %s\n",
                       $1, "RSS", "VSZ", $4
                next
            }

            {
                rss += $2
                vsz += $3

                printf "%-8s %-12s %-12s %s\n",
                       $1, fmt($2), fmt($3), $4
            }

            END {
                printf "\nTotal RSS: %s\n", fmt(rss)
                printf "Total VSZ: %s\n", fmt(vsz)
            }
        '
    end
end

set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_SDK_ROOT $ANDROID_HOME
set -gx PATH $PATH $ANDROID_HOME/emulator
set -gx PATH $PATH $ANDROID_HOME/platform-tools
set -gx PATH $PATH $ANDROID_HOME/tools
set -gx PATH $PATH $ANDROID_HOME/tools/bin

set PRETTY_NAME "Ubuntu 25.10"

# Environment variables
set -gx EDITOR nvim
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $PATH /usr/local/android-studio/bin
set -gx PATH $PATH $HOME/.cabal/bin
set -gx PATH $PATH /home/jonas/.local/share/coursier/bin

# Brew environment
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# OPAM setup
status is-interactive; and opam env | source
test -r '/home/jonas/.opam/opam-init/init.fish' && source '/home/jonas/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true

# Customize prompt colors
set fish_color_command green
set fish_color_param cyan

# Function: show your public IP
function myip
    curl ifconfig.me
end

# asdf setup
source ~/.asdf/asdf.fish

# Capacitor Android Studio path
set -gx CAPACITOR_ANDROID_STUDIO_PATH /usr/local/android-studio/bin/studio.sh
export DROPBOX_USE_WATCHDOG=False

# 1. Disable XON/XOFF flow control so the terminal leaves Ctrl+S free
if status is-interactive
    stty -ixon
end

# 2. Define the navigation function
function fzf_cd_to_file
    # Find files/directories (excluding hidden ones, up to 4 levels deep)
    set -l target (find . -maxdepth 4 -not -path '*/.*' 2>/dev/null | fzf --prompt="CD to target ❯ ")

    # Check if a target was actually selected (not cancelled via ESC)
    if test -n "$target"
        if test -f "$target"
            # If it's a file, cd to its parent folder
            cd (dirname "$target")
        else
            # If it's already a directory, cd straight into it
            cd "$target"
        end
        # Force Fish to redraw the command line prompt at the new path
        commandline -f repaint
    end
end

# 3. Bind Ctrl+S to execute our new function
# Note: \cs is the escape sequence Fish uses for Ctrl+S
bind \cs fzf_cd_to_file

# Function to find a file using fzf and open it directly in Neovim
function fzf_open_in_nvim
    # Find files only, ignoring hidden system files
    set -l selection (find . -maxdepth 4 -type f -not -path '*/.*' 2>/dev/null | fzf --prompt="Open in Neovim ❯ ")

    # If a file was successfully chosen, launch nvim with it
    if test -n "$selection"
        # commandline -t "" clears any partial command you typed before hitting the shortcut
        commandline -t ""
        nvimin "$selection"
        commandline -f repaint
    end
end

# Bind Ctrl+V to open files in Neovim
# Note: \cv is the escape sequence Fish uses for Ctrl+V
bind \ce fzf_open_in_nvim
