#ifndef PARALISTMODEL_H
#define PARALISTMODEL_H

#include <QAbstractListModel>

class ParaList;

class ParaListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(ParaList *list READ list WRITE setList)

public:
    explicit ParaListModel(QObject *parent = nullptr);

    enum {
        KeyRole,
        ValueRole,
        UnitRole
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    // Editable:
    bool setData(const QModelIndex &index, const QVariant &value,
                 int role = Qt::EditRole) override;

    Qt::ItemFlags flags(const QModelIndex& index) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    ParaList *list() const;
    void setList(ParaList *list);

private:
    ParaList *mList;
};

#endif // PARALISTMODEL_H
