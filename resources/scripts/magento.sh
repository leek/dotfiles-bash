#!/bin/bash
# usage: magento [-?][-d "ET"][-bmc -p "Test"][-o "Mage_Model_Class"]

usage()
{
cat << EOF
usage: $0 [-?][-d "ET"][-bmc -p "Test"][-o "Mage_Model_Class"]

With this script you can create your own MODULE, copy Mage class and...
OPTIONS:
   -? --help            Show this message
   -d --dev --developer Developer(s) or company name
   -p --prj --project           Create new default project
   -b --block           Create project default Block
   -m --model           Create project default Model
   -c --controller      Create project default Controller
   -o --over --override Override Mage class (object)
   -v --version         Verbose
EOF
}

DEV="ET"
MODULE=
CLASS=
BLOCK=
MODEL=
CONTROLLER=
CONFIG=
VERBOSE=
while getopts "hn:p:bmc:o:v" OPTION
do
     case $OPTION in
         \?|\-help)
             usage
             exit 1
             ;;
         d|\-dev)
             DEV=$OPTARG
             ;;
         p)
             MODULE=$OPTARG
             ;;
         o|\-over|\-override)
             CLASS=$OPTARG
             ;;
         b|\-block)
             BLOCK=${OPTARG:-"View"}
             ;;
         m|\-model)
             MODEL=1
             ;;
         c|\-controller)
             CONTROLLER=${OPTARG:-"Index"}
             ;;
         v|\-version)
             VERBOSE=1
             ;;
     esac
done
if [[ -z $MODULE ]] && [[ -z $CLASS ]] && [[ -z $VERBOSE ]]
then
    usage
    exit 1
fi

if [ "$DEV" ] && [ "$MODULE" ]
then

echo "Including Module to the project: app/etc/module/"$DEV"_"$MODULE".xml"
mkdir -p "app/etc/module/"
echo "<?xml version=\"1.0\"?>
<config>
    <modules>
        <"$DEV"_"$MODULE">
            <active>true</active>
            <codePool>local</codePool>
        </"$DEV"_"$MODULE">
    </modules>
</config>" > "app/etc/module/"$DEV"_"$MODULE".xml"

if [ "$BLOCK" ]
then

echo "Writing Block: app/code/local/"$DEV"/"$MODULE"/Block/$BLOCK.php"
mkdir -p "app/code/local/"$DEV"/"$MODULE"/Block/"
echo "<?php
/**
* @codepool Local
* @category "$DEV"
* @package  "$DEV"_"$MODULE"
* @class    "$DEV"_"$MODULE"_"$BLOCK"
*/
class "$DEV"_"$MODULE"_Block_$BLOCK extends Mage_Core_Block_Template
{
    private $message;
    private $att;

    protected function createMessage($msg) {
        $this->message = $msg;
    }

    public function receiveMessage() {
        if($this->message != '') {
            return $this->message;
        } else {
            $this->createMessage('Hello World');
            return $this->message;
        }
    }

    protected function _toHtml() {
        $html = parent::_toHtml();

        if($this->att = $this->getMyCustom() && $this->getMyCustom() != '') {
            $html .= '<br />'.$this->att;
        } else {
            $html .= '<br />No Custom Attribute Found';
        }

        return $html;
    }
}
" > "app/code/local/"$DEV"/"$MODULE"/Block/$BLOCK.php"

CONFIG+="\
<!-- Block -->\
"
fi

if [ "$CONTROLLER" ]
then

echo "Writing Controller: app/code/local/"$DEV"/"$MODULE"/controllers/"$CONTROLLER"Controller.php"
mkdir -p "app/code/local/"$DEV"/"$MODULE"/controllers/"
echo "<?php
/**
* @codepool Local
* @category "$DEV"
* @package  "$DEV"_"$MODULE"
* @class    "$DEV"_"$MODULE"_"$CONTROLLER"Controller
*/
class "$DEV"_"$MODULE"_"$CONTROLLER"Controller extends Mage_Core_Controller_Front_Action
{
        public function indexAction(){
                exit(\"ok\");
        }
}
" > "app/code/local/"$DEV"/"$MODULE"/controllers/"$CONTROLLER"Controller.php"

MODULENAME=$(echo $MODULE | tr '[A-Z]' '[a-z]');
CONFIG+="\
        <frontend>\
                <routers>\
                        <"$MODULENAME">\
                                <use>standard</use>\
                                <args>\
                                        <module>"$DEV"_"$MODULE"</module>\
                                        <frontName>"$MODULENAME"</frontName>\
                                </args>\
                        </"$MODULENAME">\
                </routers>\
        </frontend>\
"
fi


fi

echo "Writing config for module: app/code/local/"$DEV"/"$MODULE"/etc/config.xml"
mkdir -p "app/code/local/"$DEV"/"$MODULE"/etc/"
echo "<?xml version=\"1.0\"?>
<config>
    <modules>
        <"$DEV"_"$MODULE">
            <version>0.1.0</version>
        </"$DEV"_"$MODULE">
    </modules>
"$CONFIG"
    <global>
        <blocks>
            <"$DEV"_"$MODULE">
                <class>"$DEV"_"$MODULE"_Block</class>
            </"$DEV"_"$MODULE">
        </blocks>
    </global>
</config>" > "app/code/local/"$DEV"/"$MODULE"/etc/config.xml"

exit 1
fi

if [ "$CLASS" ]
then
core_dir="./app/code/core/`echo $CLASS | sed 's/_/\//g'`";
local_dir="`echo $core_dir | sed 's/core/local/1'`";
echo "Making directory..."
echo $local_dir;
mkdir -p $local_dir;
echo "Cleaning empty directory..."
rm -r $local_dir;
echo "Copyng..."
echo $core_dir.php
echo "to.."
echo $local_dir.php
cp $core_dir.php $local_dir.php;
echo "Created: "`ls $local_dir/..`

exit 1
fi
