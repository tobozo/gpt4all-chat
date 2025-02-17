function Component() {
}

var targetDirectory;
Component.prototype.beginInstallation = function() {
    targetDirectory = installer.value("TargetDir");
};

Component.prototype.createOperations = function()
{
    try {
        // call the base create operations function
        component.createOperations();
        if (systemInfo.productType === "windows") {
            try {
                var userProfile = installer.environmentVariable("USERPROFILE");
                installer.setValue("UserProfile", userProfile);
                component.addOperation("CreateShortcut",
                    targetDirectory + "/bin/chat.exe",
                    "@UserProfile@/Desktop/GPT4All.lnk",
                    "workingDirectory=" + targetDirectory + "/bin",
                    "iconPath=" + targetDirectory + "/favicon.ico",
                    "iconId=0", "description=Open GPT4All");
            } catch (e) {
                print("ERROR: creating desktop shortcut" + e);
            }
            component.addOperation("CreateShortcut",
                targetDirectory + "/bin/chat.exe",
                "@StartMenuDir@/GPT4All.lnk",
                "workingDirectory=" + targetDirectory + "/bin",
                "iconPath=" + targetDirectory + "/favicon.ico",
                "iconId=0", "description=Open GPT4All");
        } else if (systemInfo.productType === "osx") {
            targetDirectory += "/gpt4all.app/Contents/MacOS/"
        } else { // linux
            var homeDir = installer.environmentVariable("HOME");
            if (!installer.fileExists(homeDir + "/Desktop/GPT4All.desktop")) {
                component.addOperation("CreateDesktopEntry",
                    homeDir + "/Desktop/GPT4All.desktop",
                    "Type=Application\nTerminal=false\nExec=\"" + targetDirectory +
                    "/bin/chat\"\nName=GPT4All\nIcon=" + targetDirectory +
                    "/logo-48.png\nName[en_US]=GPT4All");
            }
        }
    } catch (e) {
        print("ERROR: running post installscript.qs" + e);
    }
}
