include_directories(
    ${CMAKE_BINARY_DIR}/headers
    ${CMAKE_SOURCE_DIR}/libhawaii
)

set(SOURCES
    plugin.cpp
    qmlgsettings.cpp
    qmlgsettingsschema.cpp
)

add_library(settingsplugin SHARED ${SOURCES})
target_link_libraries(settingsplugin
                      Qt5::Core
                      Qt5::Gui
                      Qt5::Qml
                      Qt5::Quick
                      Hawaii::Hawaii)

install(FILES qmldir plugins.qmltypes
    DESTINATION ${QML_INSTALL_DIR}/org/hawaii/settings)
install(TARGETS settingsplugin
    DESTINATION ${QML_INSTALL_DIR}/org/hawaii/settings)
