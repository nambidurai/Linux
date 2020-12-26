#!/bin/bash
# Developed by nambi durai ganesan

utilites()	# Standard utilites 			#
{
	sudo apt install -y bash-completion fzf ncurses-term
	# install system clipboard
	sudo apt install -y xsel
	# sudo apt install -y openssh-client
	echo source /usr/share/doc/fzf/examples/key-bindings.bash >> ~/.bashrc
	source ~/.bashrc
}

editor1()	# Neovim 				#
{
	# source list
	sudo apt-key adv --fetch-keys \
	https://deb.nodesource.com/gpgkey/nodesource.gpg.key
	sudo cp $spath/config/nodesource.list /etc/apt/sources.list.d/
	# APT update
	sudo apt update
	# nevovim
	sudo apt install -y neovim
	# python 2 and 3 dependencies
	sudo apt install -y python python3
	sudo apt install -y python-pip python3-pip
	sudo apt install -y python-setuptools python3-setuptools
	pip install neovim pynvim
  	pip3 install neovim pynvim
	# nodejs dependencies
	sudo apt install -y nodejs
	sudo npm install -g neovim
	# neovim configurations
	# install vim-plug plugin manager
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	# copy neovim configuraitons
	cp $spath/config/init.vim ~/.config/nvim/
}

editor2()	# VScode				#
{
	# microsoft GPG keys 
	sudo apt-key adv --fetch-keys \
	https://packages.microsoft.com/keys/microsoft.asc
	# source list 
	sudo cp $spath/config/vscode.list /etc/apt/sources.list.d/
	# APT update
	sudo apt update
	# install
	sudo apt install -y code libxtst6
	# install vscode extensions
	code --install-extension vscode-icons-team.vscode-icons
	code --install-extension streetsidesoftware.code-spell-checker
	code --install-extension ms-dotnettools.csharp
	code --install-extension jchannon.csharpextensions
	code --install-extension k--kato.docomment
	code --install-extension jmrog.vscode-nuget-package-manager
	# code --install-extension fernandoescolar.vscode-solution-explorer
	# code --list-extensions | xargs -L 1 echo code --install-extension
	# copy settings.jason
	cp $spath/config/settings.json ~/.config/Code/User/

}

dotnetcore()	# Dotnet core				#
{
	# microsoft GPG keys 
	sudo apt-key adv --fetch-keys \
	https://packages.microsoft.com/keys/microsoft.asc
	# dotnet core sdk source list 
	sudo cp $spath/config/dotnet.list /etc/apt/sources.list.d/
	# APT update
	sudo apt update
	# dotnet core
	sudo apt install -y dotnet-sdk-3.1
}

sqlite()	# Sqlite3 				#
{	
	sudo apt install sqlite3
}

