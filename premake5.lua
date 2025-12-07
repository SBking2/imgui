workspace "ImGui"
    configurations { "Debug", "Release" }
    architecture "x64"
    startproject "ImGui"

    outputdir = "%{cfg.buildcfg}/%{cfg.architecture}"

    project "ImGui"
    kind "StaticLib"
    language "C++"
    cppdialect "C++17"
    staticruntime "on"        -- ❗确保使用静态 CRT，避免 CRT 冲突

    targetdir ("%{wks.location}/bin/%{prj.name}/" .. outputdir)
    objdir    ("%{wks.location}/bin-int/%{prj.name}/" .. outputdir)

    files
    {
        "imgui.cpp",
        "imgui_draw.cpp",
        "imgui_widgets.cpp",
        "imgui_tables.cpp",

        "backends/imgui_impl_glfw.cpp",
        "backends/imgui_impl_glfw.h",
        "backends/imgui_impl_vulkan.cpp",
        "backends/imgui_impl_vulkan.h",

        "imconfig.h",
        "imgui.h",
        "imgui_internal.h",
        "imstb_rectpack.h",
        "imstb_textedit.h",
        "imstb_truetype.h"
    }

    includedirs
    {
        ".",
        "backends",
        "../glfw/include",
        os.getenv("VK_SDK_PATH") .. "/Include",   -- 需要你在 workspace 里定义 IncludeDir.Vulkan
    }

    filter "system:windows"
        systemversion "latest"

        -- ❗Windows 上重要：关闭 DLL CRT，使用静态 CRT
        runtime "Release"

    filter "configurations:Debug"
        defines { "DEBUG" }
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines { "NDEBUG" }
        runtime "Release"
        optimize "on"
