# php-env

[Vagrant](https://www.vagrantup.com/)と関連するプラグインをインストールする。

Macの場合[Homebrew Cask](http://caskroom.io/)をインストールしていれば簡単です。

    $ brew cask update
    $ brew cask install vagarnt virtualbox
    $ vagrant plugin install vagrant-env
    $ vagrant up
