TEMPLATE = aux

INSTALLER = installer

INPUT = $$PWD/config/config.xml $$PWD/packages

AppPack.input = INPUT
AppPack.output = $$INSTALLER
AppPack.commands = ../bin/binarycreator -c $$PWD/config/config.xml -p $$PWD/packages ${QMAKE_FILE_OUT}
AppPack.CONFIG += target_predeps no_link combine

QMAKE_EXTRA_COMPILERS += AppPack

OTHER_FILES = README
