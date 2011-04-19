#!/bin/bash


generate_project()
{
    cat > .project <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
	<name>${1}</name>
	<comment></comment>
	<projects>
	</projects>
	<buildSpec>
		<buildCommand>
			<name>org.eclipse.jdt.core.javabuilder</name>
			<arguments>
			</arguments>
		</buildCommand>
	</buildSpec>
	<natures>
		<nature>org.eclipse.jdt.core.javanature</nature>
	</natures>
</projectDescription>
EOF
}

generate_classpath()
{
    cat > .classpath <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<classpath>
	<classpathentry kind="src" path="src"/>
	<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.6"/>
	<classpathentry kind="output" path="bin"/>
</classpath>
EOF
}

generate_settings_folder()
{
    test -d .settings || mkdir .settings
    cat > .settings/org.eclipse.jdt.core.prefs <<EOF
#$(date)
eclipse.preferences.version=1
org.eclipse.jdt.core.compiler.codegen.inlineJsrBytecode=enabled
org.eclipse.jdt.core.compiler.codegen.targetPlatform=1.6
org.eclipse.jdt.core.compiler.codegen.unusedLocal=preserve
org.eclipse.jdt.core.compiler.compliance=1.6
org.eclipse.jdt.core.compiler.debug.lineNumber=generate
org.eclipse.jdt.core.compiler.debug.localVariable=generate
org.eclipse.jdt.core.compiler.debug.sourceFile=generate
org.eclipse.jdt.core.compiler.problem.assertIdentifier=error
org.eclipse.jdt.core.compiler.problem.enumIdentifier=error
org.eclipse.jdt.core.compiler.source=1.6
EOF
}


PROJECT_DIR=$(echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS"|head -n1)
PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd)
PROJECT_NAME=$(expr "$PROJECT_DIR" : '.*/\([A-Za-z0-9_\-][A-Za-z0-9_\-]*\)')
PROJECT_LOCATION=$(expr "$PROJECT_DIR" : '\(.*\)/[A-Za-z0-9_\-][A-Za-z0-9_\-]*')

echo $PROJECT_LOCATION

cd "$PROJECT_DIR" || {
    echo "Failed to change directory"; exit 1
}

generate_project "$PROJECT_NAME"
generate_classpath
generate_settings_folder

cd "$PROJECT_LOCATION"
test -f "$PROJECT_NAME.zip" || rm "$PROJECT_NAME.zip"

echo "Zipping archive ..."
find "$PROJECT_NAME" -name '*.prefs' \
    -or -name '*.java' \
    -or -name '.classpath' \
    -or -name '.project' | zip "$PROJECT_NAME.zip" -@

echo "finish!"
