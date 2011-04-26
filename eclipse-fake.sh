#!/bin/bash

# Override these variables in ~/.eclipse-fake-rc
ECLIPSE_JAVA_VERSION=1.6
ECLIPSE_SRC_DIR=src
ECLIPSE_OUTPUT_DIR=bin

test -f ~/.eclipse-fake-rc && source ~/.eclipse-fake-rc

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
	<classpathentry kind="src" path="${ECLIPSE_SRC_DIR}"/>
	<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER/org.eclipse.jdt.internal.debug.ui.launcher.StandardVMType/JavaSE-1.6"/>
	<classpathentry kind="output" path="${ECLIPSE_OUTPUT_DIR}"/>
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
org.eclipse.jdt.core.compiler.codegen.targetPlatform=${ECLIPSE_JAVA_VERSION}
org.eclipse.jdt.core.compiler.codegen.unusedLocal=preserve
org.eclipse.jdt.core.compiler.compliance=1.6
org.eclipse.jdt.core.compiler.debug.lineNumber=generate
org.eclipse.jdt.core.compiler.debug.localVariable=generate
org.eclipse.jdt.core.compiler.debug.sourceFile=generate
org.eclipse.jdt.core.compiler.problem.assertIdentifier=error
org.eclipse.jdt.core.compiler.problem.enumIdentifier=error
org.eclipse.jdt.core.compiler.source=${ECLIPSE_JAVA_VERSION}
EOF
}

PROJECT_DIR=
if ! [[ -z $1 ]]; then
    PROJECT_DIR=$1
else
    PROJECT_DIR=$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
fi

PROJECT_DIR=$(echo "$PROJECT_DIR"|head -n1)

test -d "$PROJECT_DIR" || {
    echo "Project-dir is not a directory" >&2 ; exit 1
}

PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd)
PROJECT_NAME=$(expr "$PROJECT_DIR" : '.*/\([A-Za-z0-9_\-][A-Za-z0-9_\-]*\)')
PROJECT_LOCATION=$(expr "$PROJECT_DIR" : '\(.*\)/[A-Za-z0-9_\-][A-Za-z0-9_\-]*')

echo $PROJECT_LOCATION

cd "$PROJECT_DIR" || {
    echo "Failed to change directory" >&2 ; exit 1
}

generate_project "$PROJECT_NAME"
generate_classpath
generate_settings_folder

cd "$PROJECT_LOCATION"
test -f "$PROJECT_NAME.zip" && rm "$PROJECT_NAME.zip"

echo "Zipping archive ..."
find "$PROJECT_NAME" -name '*.prefs' \
    -or -name '*.java' \
    -or -name '.classpath' \
    -or -name '.project' | zip "$PROJECT_NAME.zip" -@

echo "finish!"
