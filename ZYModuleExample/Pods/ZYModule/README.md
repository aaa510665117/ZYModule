# ZYModule

自定义方法、类库,用于快速集成项目 
****

|Author|ZY|
|---|---
|E-mail|510665117@qq.com


##  use:     pod 'ZYModule'  

### 语音录入相关 
AudioVoice

### 自定义刷新组件   
DiyMjRefresh 

### 语音识别组件  
SpeechRecognizer

### 数据库  
ZYDataBaseManager

### 扩展类  
ZYExternClass

### 网络请求相关 
SEHttp  

### 常用方法组件
ZYToolsFunction


shell:  
pod spec create ZYModule  
git tag -m"pod spec" "0.0.1"  
git push origin --tags  
pod trunk me(login in)  
pod lib lint --allow-warnings --use-libraries  
pod sepc lint --allow-warnings  
pod trunk push ZYModule.podspec --allow-warnings --use-libraries
