LSHttpGetManager
================

A lightweight http get request manager, easy to download data from a static url.

####A lightweight http tool to request data

LSHttpGetManager is a wrapper of NSURLConnection. It sends a http url and return the received data from web server.

####Installation

Just download and copy the [LSHttpGetManager](https://github.com/tinymind/LSHttpGetManager/tree/master/LSHttpGetManager) to your project.

Or:

```cpp

$ git https://github.com/tinymind/LSHttpGetManager.git

```

####Usage

```cpp

#import "LSHttpGetManager.h"

- (void)onDownloadButtonTouched:(id)sender
{
  [[LSHttpGetManager sharedObject] sendHttpRequestWithUrl:self.url taskKey:self.taskKey completion:^(BOOL succeed, NSData *recvData, NSError *error) {
            if (succeed) {
                self.imgView.image = [UIImage imageWithData:recvData];
            }
        }];

}

```

####Example

![Example](https://github.com/tinymind/LSHttpGetManager/tree/master/example.png)