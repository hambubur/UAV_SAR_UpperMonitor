#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QFontDatabase>
#include <QDebug>

#include "src/component/CircularReveal.h"
#include "src/component/FileWatcher.h"
#include "src/component/FpsItem.h"
#include "src/helper/SettingsHelper.h"
#include "src/helper/Log.h"
#include "src/AppInfo.h"


int main(int argc, char *argv[])
{
    QGuiApplication::setOrganizationName("Sid Han");
    QGuiApplication::setApplicationName("UAV_SAR_UpperMonitor");

    SettingsHelper::getInstance()->init(argv);
    Log::setup("UAV_SAR_UpperMonitor");

    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon("UAV_SAR_UpperMonitor/res/img/favicon.ico"));
    QFontDatabase::addApplicationFont("UAV_SAR_UpperMonitor/res/font/SmileySans-Oblique.ttf");


    QQmlApplicationEngine engine;

    QQmlContext* context = engine.rootContext();
    QScreen* screen = QGuiApplication::primaryScreen();
    QRect rect = screen->virtualGeometry();
    context->setContextProperty("SCREEN_WIDTH", rect.width());
    context->setContextProperty("SCREEN_HEIGHT", rect.height());

    AppInfo::getInstance()->init(&engine);
    engine.rootContext()->setContextProperty("AppInfo",AppInfo::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper",SettingsHelper::getInstance());
    qmlRegisterType<CircularReveal>("UAV_SAR_UpperMonitor", 1, 0, "CircularReveal");
    qmlRegisterType<FileWatcher>("UAV_SAR_UpperMonitor", 1, 0, "FileWatcher");
    qmlRegisterType<FpsItem>("UAV_SAR_UpperMonitor", 1, 0, "FpsItem");

    QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);

    const QUrl url(u"qrc:/UAV_SAR_UpperMonitor/qml/App.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);


    // XMLHttpRequest 允许读取本地文件
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));

    return app.exec();
}
