#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>
#include <QQuickWindow>
#include <QNetworkProxy>
#include <QSslConfiguration>
#include <QProcess>
#include <QtQml/qqmlextensionplugin.h>
#include <QLoggingCategory>
#include "src/helper/Version.h"
#include "src/AppInfo.h"
#include "src/helper/Log.h"
#include "src/component/CircularReveal.h"
#include "src/component/FileWatcher.h"
#include "src/component/FpsItem.h"
#include "src/helper/SettingsHelper.h"
#include "src/helper/TranslateHelper.h"

#ifdef FLUENTUI_BUILD_STATIC_LIB
#if (QT_VERSION > QT_VERSION_CHECK(6, 2, 0))
Q_IMPORT_QML_PLUGIN(FluentUIPlugin)
#endif
#include <FluentUI.h>
#endif

#ifdef WIN32
#include "src/app_dmp.h"
#endif

int main(int argc, char *argv[])
{
#ifdef WIN32
    ::SetUnhandledExceptionFilter(MyUnhandledExceptionFilter);
    qputenv("QT_QPA_PLATFORM","windows:darkmode=2");
#endif
#if (QT_VERSION >= QT_VERSION_CHECK(6, 0, 0))
    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");
#else
    qputenv("QT_QUICK_CONTROLS_STYLE","Default");
#endif
#ifdef Q_OS_LINUX
    //fix bug UOSv20 does not print logs
    qputenv("QT_LOGGING_RULES","");
    //fix bug UOSv20 v-sync does not work
    qputenv("QSG_RENDER_LOOP","basic");
#endif
    QGuiApplication::setOrganizationName("Sid");
    QGuiApplication::setOrganizationDomain("https://hambubur.github.io");
    QGuiApplication::setApplicationName("UAV_SAR_UpperMonitor");
    QGuiApplication::setApplicationDisplayName("UAV-SAR UpperMonitor");
    QGuiApplication::setApplicationVersion(APPLICATION_VERSION);
    SettingsHelper::getInstance()->init(argv);
    Log::setup(argv,"UAV_SAR_UpperMonitor");
#if (QT_VERSION >= QT_VERSION_CHECK(6, 5, 0))
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
#endif
#if (QT_VERSION < QT_VERSION_CHECK(6, 0, 0))
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);
#endif
#endif
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    TranslateHelper::getInstance()->init(&engine);
    engine.rootContext()->setContextProperty("AppInfo",AppInfo::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper",SettingsHelper::getInstance());
    engine.rootContext()->setContextProperty("TranslateHelper",TranslateHelper::getInstance());
#ifdef FLUENTUI_BUILD_STATIC_LIB
    FluentUI::getInstance()->registerTypes(&engine);
#endif

    // 设置窗口图标
    app.setWindowIcon(QIcon("qrc:/res/img/favicon.ico"));

    // 根据屏幕分辨率设置窗口大小
    QQmlContext* context = engine.rootContext();
    QScreen* screen = QGuiApplication::primaryScreen();
    QRect rect = screen->virtualGeometry();
    context->setContextProperty("SCREEN_WIDTH", rect.width());
    context->setContextProperty("SCREEN_HEIGHT", rect.height());

    // XMLHttpRequest 允许读取本地文件
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));

    qmlRegisterType<CircularReveal>("UAV_SAR_UpperMonitor", 1, 0, "CircularReveal");
    qmlRegisterType<FileWatcher>("UAV_SAR_UpperMonitor", 1, 0, "FileWatcher");
    qmlRegisterType<FpsItem>("UAV_SAR_UpperMonitor", 1, 0, "FpsItem");
    const QUrl url(QStringLiteral("qrc:/qml/App.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);
    const int exec = QGuiApplication::exec();
    if (exec == 931) {
        QProcess::startDetached(qApp->applicationFilePath(), QStringList());
    }
    return exec;
}
