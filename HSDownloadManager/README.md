根据HSDownloadManager 进行修改，目前代码还在技继更新中...

添加了数据库的支持，
添加了对任意类型数据存库
支持分状态显示下载数据

# HSDownloadManager
下载音乐、视频、图片各种资源，支持多任务、断点下载


```objc

/**
*  开启任务下载资源
*
*  @param url           下载地址
*  @param progressBlock 回调下载进度
*  @param stateBlock    下载状态
*/
- (void)download:(NSString *)url progress:(void(^)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress))progressBlock state:(void(^)(DownloadState state))stateBlock;

- (void)download:(NSString *)url local:(NSString*)localFile size:(long)downloaded_size
progress:(void (^)(NSInteger, NSInteger, CGFloat))progressBlock state:(void (^)(DownloadState))stateBlock;

- (void)downloadObject:(DownloadObject*) down_obj progress:(void (^)(NSInteger, NSInteger, CGFloat))progressBlock state:(void (^)(DownloadState))stateBlock;

/**
*  查询该资源的下载进度值
*
*  @param url 下载地址
*
*  @return 返回下载进度值
*/
- (CGFloat)progress:(NSString *)url;

/**
*  获取该资源总大小
*
*  @param url 下载地址
*
*  @return 资源总大小
*/
- (NSInteger)fileTotalLength:(NSString *)url;

/**
*  判断该资源是否下载完成
*
*  @param url 下载地址
*
*  @return YES: 完成
*/
- (BOOL)isCompletion:(NSString *)url;

/**
*  删除该资源
*
*  @param url 下载地址
*/
- (void)deleteFile:(NSString *)url;

/**
*  清空所有下载资源
*/
- (void)deleteAllFile;


```