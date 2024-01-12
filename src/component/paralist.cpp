#include "paralist.h"

ParaList::ParaList(QObject *parent)
    : QObject{parent}
{
    mItems.append({QStringLiteral("key1"), 1, QStringLiteral("unit1")});
    mItems.append({QStringLiteral("key2"), 2, QStringLiteral("unit2")});
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

void ParaList::appendItem(QString key, int value, QString unit)
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
