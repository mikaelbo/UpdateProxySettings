# UpdateProxySettings

A simple iOS command line tool for updating proxy settings. Based on [Danny Liu](https://github.com/DYun)'s project, [iOSProxyManager](https://github.com/DYun/iOSProxyManager). 

Requires a jailbroken phone with <b>iOS 8+</b>.

## Usage

To update proxy settings

```
UpdateProxySettings [proxy] [port]
```

To turn proxy off

```
UpdateProxySettings off
```

*The commands need to be run as root.*

## Installation
Make sure you have [Theos](https://github.com/theos/theos) installed (guide found [here](http://iphonedevwiki.net/index.php/Theos/Setup)), with the `$THEOS` and `$THEOS_DEVICE_IP` variables configured. 

After that just run `make package install` in the console from the project directory.
