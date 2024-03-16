import os

# 指定你想要扫描的目录
directories = ['qml', 'src', 'res', "cfg"]

# 打开你的.qrc文件
with open('qml.qrc', 'w') as f:
    f.write('<RCC>\n')
    f.write('    <qresource prefix="/">\n')

    # 遍历每个目录
    for directory in directories:
        # 遍历目录中的每个文件
        for root, dirs, files in os.walk(directory):
            for file in files:
                # 将文件的路径添加到.qrc文件中
                f.write('        <file>' + os.path.join(root, file) + '</file>\n')

    f.write('    </qresource>\n')
    f.write('</RCC>\n')

# 打印
print('qml.qrc 文件已经更新')
