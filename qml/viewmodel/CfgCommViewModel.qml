import QtQuick
import FluentUI

FluViewModel{

    objectName: "CfgCommViewModel"
    scope: FluViewModelType.Application

    // 配置文件路径
    property string cfgPath: "qrc:/UAV_SAR_UpperMonitor/cfg/communication.json"
    // 
    property var dca1000Config

    signal loadCfg
    signal saveCfg

    onInitData: {
        loadcfg(cfgPath)
    }

    onLoadCfg: {
        if(loadCfg(cfgPath)){
            console.debug(qsTr("成功加载参数:"), cfgPath)
        }else{
            console.debug(qsTr("参数加载失败"))
        }
    }

    onSaveCfg: {
        if(savecfg(cfgPath)){
            showSuccess("保存成功")
            console.debug("参数保存在", cfgPath)
        }else{
            showError("保存失败")
            console.debug("参数保存失败")
        }
    }

    /**
     * @function loadcfg
     * @param {String} path
     * @return {Object}
     * 
     * @brief 加载配置文件
     */

    function loadcfg(path)
    {
        var file = new XMLHttpRequest()
        var cfg

        file.open("GET", path, false)   // false表示同步请求
        file.send(null)

        if (file.status == 200)     // 200表示请求成功
        {
            cfg = JSON.parse(file.responseText)

            // 如果cfg为空,则返回
            if (cfg === {})
            {
                showError("配置文件为空")
                console.debug("配置文件为空")
                return false
            }

            dca1000Config = cfg["DCA1000Config"]

            // 详细打印出cfg所有内容
            // console.log("cfg: ", JSON.stringify(cfg))

            return true
        }
        else
        {
            showError("读取配置文件失败")
            console.debug("读取配置文件失败")
            return false
        }
    }

    /**
     * @function savecfg
     * @param {String} path
     * @return {Boolean}
     * 
     * @brief 保存配置文件,成功返回true,失败返回false
     */
    function savecfg(path)
    {
        var cfg = {
            "DCA1000Config": dca1000Config
        }
        var file = new XMLHttpRequest()
        file.open("POST", path, false)
        file.send(JSON.stringify(cfg))
        if (file.status == 200)
        {
            return true
        }
        return false
    }

    function checkcfg()
    {
        if (dca1000Config === {})
        {
            showError("参数不完整")
            console.debug("参数不完整")
            return false
        }
        return true
    }

}
