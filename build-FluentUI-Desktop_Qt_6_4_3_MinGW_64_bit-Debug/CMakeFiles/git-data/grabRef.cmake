set(HEAD_HASH)
file(READ "C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/build-FluentUI-Desktop_Qt_6_4_3_MinGW_64_bit-Debug/CMakeFiles/git-data/HEAD" HEAD_CONTENTS LIMIT 1024)
string(STRIP "${HEAD_CONTENTS}" HEAD_CONTENTS)
if(HEAD_CONTENTS MATCHES "ref")
    string(REPLACE "ref: " "" HEAD_REF "${HEAD_CONTENTS}")
    if(EXISTS "C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/.git/${HEAD_REF}")
        configure_file("C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/.git/${HEAD_REF}" "C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/build-FluentUI-Desktop_Qt_6_4_3_MinGW_64_bit-Debug/CMakeFiles/git-data/head-ref" COPYONLY)
    else()
        configure_file("C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/.git/packed-refs" "C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/build-FluentUI-Desktop_Qt_6_4_3_MinGW_64_bit-Debug/CMakeFiles/git-data/packed-refs" COPYONLY)
        file(READ "C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/build-FluentUI-Desktop_Qt_6_4_3_MinGW_64_bit-Debug/CMakeFiles/git-data/packed-refs" PACKED_REFS)
            if(${PACKED_REFS} MATCHES "([0-9a-z]*) ${HEAD_REF}")
                set(HEAD_HASH "${CMAKE_MATCH_1}")
            endif()
    endif()
else()
    configure_file("C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/.git/HEAD" "C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/build-FluentUI-Desktop_Qt_6_4_3_MinGW_64_bit-Debug/CMakeFiles/git-data/head-ref" COPYONLY)
endif()
if(NOT HEAD_HASH)
    file(READ "C:/Users/h/Ti_Radar/QtProject/UAV_SAR_UpperMonitor/build-FluentUI-Desktop_Qt_6_4_3_MinGW_64_bit-Debug/CMakeFiles/git-data/head-ref" HEAD_HASH LIMIT 1024)
    string(STRIP "${HEAD_HASH}" HEAD_HASH)
endif()
