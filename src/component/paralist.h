#ifndef PARALIST_H
#define PARALIST_H

#include <QObject>
#include <QVector>
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

struct ParaItem
{
    QString key;
    QVariant value;
    QString unit;
};

class ParaList : public QObject
{
    Q_OBJECT
public:
    explicit ParaList(QObject *parent = nullptr);

    QVector<ParaItem> items() const;

    bool setItemAt(int index, const ParaItem &item);

    bool loadFromJson(const QString &filePath);

signals:
    void preItemAppended();
    void postItemAppended();

    void preItemRemoved(int index);
    void postItemRemoved();

public slots:
    void appendItem(QString key, QVariant value, QString unit);
    void removeItem(int index);

private:
    QVector<ParaItem> mItems;
    QMap<QString, QString> unitMap;
};

#endif // PARALIST_H
