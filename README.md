# ZYModule

自定义三方类库,用于快速集成项目 
****

|Author|ZY|
|---|---
|E-mail|510665117@qq.com


##  use:     pod 'ZYModule'  



### 网络请求相关 
SEHttp  

### 自定义刷新组件   
DiyMjRefresh   

### 自定义扩展组件
ZYExternClass  
**UIImge+Blur    （cannot find interface declaration for 'UIImage'）报错解决 需在pch文件内引入#import <UIKit/UIKit.h>


shell:
pod spec create JHDynamicFont
git tag -m"pod spec" "0.0.1"
git push origin --tags
pod trunk me(login in)
pod lib lint --allow-warnings
pod sepc lint --allow-warnings
pod trunk push JHDynamicFont.podspec --allow-warnings
