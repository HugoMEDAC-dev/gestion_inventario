allprojects {
    repositories {
        google()
        mavenCentral()
        jcenter()
    }
}
buildscript {
    repositories {
        google()
        mavenCentral()
    }


    dependencies {
        add("classpath", "com.android.tools.build:gradle:8.0.0")
        add("classpath", "com.google.gms:google-services:4.4.2") 
        add("classpath", "org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.20")
    }
}


val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
