import router from '@ohos.router';
import { CommonConstants } from '../constants/CommonConstants';
import { BottomTabs } from '../components/BottomTabs';
import { BackendService } from '../services/BackendService';

@Entry
@Component
struct DetailPage {
  @State herbData: any = null; // 当前中药材数据

  async aboutToAppear() {
    const params = router.getParams() as { contentId?: number };
    const contentId = params?.contentId;
    if (contentId) {
      try {
        this.herbData = await BackendService.fetchHerbDetail(contentId);
      } catch (e) {
        // 错误处理
      }
    }
  }

  // 返回上一页
  private goBack() {
    router.back();
  }

  build() {
    Column() {
      // 返回按钮
      Row() {
        Button() {
          Text('返回')
            .fontSize(16)
            .fontColor('#FFFFFF')
        }
        .width(60)
        .height(40)
        .backgroundColor('#007AFF')
        .borderRadius(8)
        .margin({ left: 10, top: 10 })
        .onClick(() => this.goBack())
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)

      // 标题
      Text(this.herbData?.herb_name || '中药详情')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ left: 10, top: 10, bottom: 10 })

      // 图片
      Image(this.herbData?.image_url || CommonConstants.IMAGE_URL_1)
        .width('100%')
        .height(200)
        .objectFit(ImageFit.Cover)
        .borderRadius(8)
        .margin({ left: 10, right: 10, bottom: 10 })

      // 详细信息
      Scroll() {
        Column() {
          // 拼音
          Row() {
            Text('拼音：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.pinyin || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 别名
          Row() {
            Text('别名：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.alias || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 性味
          Row() {
            Text('性味：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.property || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 归经
          Row() {
            Text('归经：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.meridian || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 功效
          Row() {
            Text('功效：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.efficacy || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 主治
          Row() {
            Text('主治：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.indications || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 用法用量
          Row() {
            Text('用法用量：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.usage || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 使用禁忌
          Row() {
            Text('使用禁忌：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.contraindication || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 产地
          Row() {
            Text('产地：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(this.herbData?.production_area || '无')
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          // 浏览量、点赞数、收藏数
          Row() {
            Text('浏览量：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(`${this.herbData?.views || 0}`)
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          Row() {
            Text('点赞数：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(`${this.herbData?.likes || 0}`)
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

          Row() {
            Text('收藏数：')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width(100)
            Text(`${this.herbData?.collections || 0}`)
              .fontSize(14)
              .fontColor('#666666')
          }
          .width('100%')
          .padding(10)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })
        }
        .width('100%')
        .padding({ left: 10, right: 10 })
      }
      .layoutWeight(1)
      .flexGrow(1)
      .width('100%')

      // 底部导航栏
      BottomTabs();
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}