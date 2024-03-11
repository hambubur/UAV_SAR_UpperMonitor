#include "paralist.h"

ParaList::ParaList(QObject *parent)
    : QObject{parent}
{
    mItems.append({QStringLiteral("key1"), 1, QStringLiteral("unit1")});
    mItems.append({QStringLiteral("key2"), 2, QStringLiteral("unit2")});

    // 初始化单位映射
    unitMap.insert("startFreqConst", "GHz");
    unitMap.insert("idleTimeConst", "us");
    unitMap.insert("adcStartTimeConst", "GHz");
    unitMap.insert("key2", "unit2");
}

QVector<ParaItem> ParaList::items() const
{
    return mItems;
}

bool ParaList::setItemAt(int index, const ParaItem &item)
{
    if(index < 0 || index >= mItems.size())
        return false;

    const ParaItem &oldItem = mItems.at(index);
    if(item.value == oldItem.value)
        return false;

    mItems[index] = item;
    return true;
}

bool ParaList::loadFromJson(const QString &filePath)
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning("Couldn't open file.");
        return false;
    }

    QByteArray data = file.readAll();
    QJsonDocument doc(QJsonDocument::fromJson(data));

    if (!doc.isObject()) {
            qWarning("JSON is not an object.");
            return false;
        }

    QJsonObject obj = doc.object();
    for (auto it = obj.begin(); it != obj.end(); ++it) {
        ParaItem item;
        item.key = it.key();
        item.value = it.value().toVariant();
        item.unit = unitMap.value(item.key, ""); // 根据key查找单位，如果找不到则使用空字符串
        appendItem(item.key, item.value, item.unit);
    }
    return true;
}

void ParaList::appendItem(QString key, QVariant value, QString unit)
{
    emit preItemAppended();

    ParaItem item;
    item.key = key;
    item.value = value;
    item.unit = unit;
    mItems.append(item);

    emit postItemAppended();
}

void ParaList::removeItem(int index)
{
    emit preItemRemoved(index);
    mItems.removeAt(index);
    emit postItemRemoved();
}
