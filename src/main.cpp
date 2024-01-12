#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>

#include "component/paralist.h"
#include "component/paralistmodel.h"

#include "component/CircularReveal.h"
#include "component/FileWatcher.h"
#include "component/FpsItem.h"
#include "helper/SettingsHelper.h"
#include "helper/Log.h"
#include "AppInfo.h"


int main(int argc, char *argv[])
{
    QGuiApplication::setOrganizationName("Sid Han");
    QGuiApplication::setApplicationName("UAV_SAR_UpperMonitor");

    SettingsHelper::getInstance()->init(argv);
    Log::setup("UAV_SAR_UpperMonitor");

    qputenv("QT_QUICK_CONTROLS_STYLE","Basic");

    QGuiApplication app(argc, argv);

    ParaList paraList;

    QQmlApplicationEngine engine;

    QQmlContext* context = engine.rootContext();
    QScreen* screen = QGuiApplication::primaryScreen();
    QRect rect = screen->virtualGeometry();
    context->setContextProperty("SCREEN_WIDTH", rect.width());
    context->setContextProperty("SCREEN_HEIGHT", rect.height());

    AppInfo::getInstance()->init(&engine);
    engine.rootContext()->setContextProperty("AppInfo",AppInfo::getInstance());
    engine.rootContext()->setContextProperty("SettingsHelper",SettingsHelper::getInstance());
    engine.rootContext()->setContextProperty(QStringLiteral("paraList"), &paraList);
    qmlRegisterType<CircularReveal>("UAV_SAR_UpperMonitor", 1, 0, "CircularReveal");
    qmlRegisterType<FileWatcher>("UAV_SAR_UpperMonitor", 1, 0, "FileWatcher");
    qmlRegisterType<FpsItem>("UAV_SAR_UpperMonitor", 1, 0, "FpsItem");
    qmlRegisterType<ParaListModel>("UAV_SAR_UpperMonitor", 1, 0, "ParaListModel");
    qmlRegisterUncreatableType<ParaList>("UAV_SAR_UpperMonitor", 1, 0, "ParaList",
        QStringLiteral("ParaList should not be created in QML"));

    QQuickWindow::setGraphicsApi(QSGRendererInterface::Software);

    const QUrl url(u"qrc:/UAV_SAR_UpperMonitor/qml/App.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
