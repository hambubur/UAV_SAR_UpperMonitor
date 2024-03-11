#include "paralistmodel.h"
#include "paralist.h"

ParaListModel::ParaListModel(QObject *parent)
    : QAbstractListModel(parent)
    , mList(nullptr)
{
}

int ParaListModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid() || !mList)
        return 0;

    return mList->items().size();
}

QVariant ParaListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || !mList)
        return QVariant();

    const ParaItem item = mList->items().at(index.row());
    switch(role){
    case KeyRole:
        return QVariant(item.key);
    case ValueRole:
        return QVariant(item.value);
    case UnitRole:
        return QVariant(item.unit);
    }

    return QVariant();
}

bool ParaListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (!mList)
        return false;

    ParaItem item = mList->items().at(index.row());

    switch(role){
    case KeyRole:
        item.key = value.toString();
        break;
    case ValueRole:
        item.value = value;
        break;
    case UnitRole:
        item.unit = value.toString();
        break;
    }

    if (mList->setItemAt(index.row(), item)) {
        // FIXME: Implement me!
        emit dataChanged(index, index, {role});
        return true;
    }
    return false;
}

Qt::ItemFlags ParaListModel::flags(const QModelIndex &index) const
{
    if (!index.isValid())
        return Qt::NoItemFlags;

    return QAbstractItemModel::flags(index) | Qt::ItemIsEditable;
}

QHash<int, QByteArray> ParaListModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[KeyRole] = "key";
    names[ValueRole] = "value";
    names[UnitRole] ="unit";
    return names;
}

ParaList *ParaListModel::list() const
{
    return mList;
}

void ParaListModel::setList(ParaList *list)
{
    beginResetModel();

    if(mList)
        mList->disconnect(this);

    mList = list;

    if(mList){
        connect(mList, &ParaList::preItemAppended, this, [=](){
            const int index = mList->items().size();
            beginInsertRows(QModelIndex(), index, index);
        });
        connect(mList, &ParaList::postItemAppended, this, [=](){
            endInsertRows();
        });

        connect(mList, &ParaList::preItemRemoved, this, [=](int index){
            beginRemoveRows(QModelIndex(), index, index);
        });
        connect(mList, &ParaList::postItemRemoved, this, [=](){
            endRemoveRows();
        });
    }

    endResetModel();
}
