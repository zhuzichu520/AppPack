// 实用函数，类似于 QString QDir::toNativeSeparators()
var Dir = new function () {
    this.toNativeSparator = function (path) {
        if (installer.value("os") == "win")
            return path.replace(/\//g, '\\');
        return path;
    }
};

//加载qs文件调用
function Component()
{
    //修改协议
    if (!installer.isCommandLineInstance())
        gui.pageWidgetByObjectName("LicenseAgreementPage").entered.connect(changeLicenseLabels);
    //加载注册页面
    installer.addWizardPageItem(component, "RegisterForm", QInstaller.TargetDirectory);
    installer.installationFinished.connect(this, Component.prototype.installationFinishedPageIsShown);
    installer.finishButtonClicked.connect(this, Component.prototype.installationFinished);
}

changeLicenseLabels = function()
{
    page = gui.pageWidgetByObjectName("LicenseAgreementPage");
    page.AcceptLicenseLabel.setText("我同意!");
}


//安装完成后调用
Component.prototype.createOperations = function()
{
    component.createOperations();

    var isShortcutChecked = component.userInterface( "RegisterForm" ).isShortcutCheckBox.checked;
    if(isShortcutChecked){
        //创建菜单快捷方式
        component.addOperation("CreateShortcut", "@TargetDir@/Test.exe", "@StartMenuDir@/Test.lnk",
                               "workingDirectory=@TargetDir@", "iconPath=@TargetDir@/Test.exe",
                               "iconId=0", "description=@TargetDir@/Test.exe");
        //创建桌面快捷方式
        component.addOperation("CreateShortcut", "@TargetDir@/Test.exe", "@HomeDir@/Desktop/Test.lnk",
                               "workingDirectory=@TargetDir@", "iconPath=@TargetDir@/Test.exe",
                               "iconId=0", "description=@TargetDir@/Test.exe");
    }

    var isAutoChecked = component.userInterface( "RegisterForm" ).isAutoCheckBox.checked;
    if (isAutoChecked) {
        //开机自启
        component.addOperation("GlobalConfig", "HKEY_CURRENT_USER\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", "Test",Dir.toNativeSparator(installer.value("TargetDir")+"/Test.exe"));
    }

}

//完成界面显示调用
Component.prototype.installationFinishedPageIsShown = function()
{
    try {
        if (installer.isInstaller() && installer.status == QInstaller.Success) {
            installer.addWizardPageItem( component, "OpenExeForm", QInstaller.InstallationFinished );
        }
    } catch(e) {
        console.log(e);
    }
}

//点击确定后调用
Component.prototype.installationFinished = function()
{
    try {
        if (installer.isInstaller() && installer.status == QInstaller.Success) {
            var isOpenExeChecked = component.userInterface( "OpenExeForm" ).isOpenCheckBox.checked;
            if (isOpenExeChecked) {
                QDesktopServices.openUrl("file:///"+installer.value("TargetDir")+"/Test.exe");
            }
        }
    } catch(e) {
        console.log(e);
    }
}
