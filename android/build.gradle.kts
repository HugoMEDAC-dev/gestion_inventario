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
    classpath("com.google.gms:google-services:4.4.2") 
    implementation(platform("com.google.firebase:firebase-bom:33.12.0"))
    implementation("com.google.firebase:firebase-inappmessaging-display")
    implementation("com.google.fiebase:firebase-analytics")
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
