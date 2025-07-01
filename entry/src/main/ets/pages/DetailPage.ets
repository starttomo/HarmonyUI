import router from '@ohos.router';
import { CommonConstants } from '../constants/CommonConstants';
import { BottomTabs } from '../components/BottomTabs';

// 模拟中药材数据
export const HERB_LIST = [
  {
    herb_id: 1,
    herb_name: '人参',
    category_id: 1,
    pinyin: 'Ren Shen',
    alias: '人葠,黄参',
    property: '甘、微苦，温',
    meridian: '归脾、肺、心经',
    efficacy: '大补元气，复脉固脱，补脾益肺，生津安神',
    indications: '体虚欲脱，肢冷脉微，脾虚食少，肺虚喘咳，津伤口渴，内热消渴，气血亏虚，神疲心悸，失眠健忘',
    usage: '煎服：3-9g；或入丸、散。研末吞服，每次1-2g',
    contraindication: '实证、热证忌服；不宜与藜芦同用',
    production_area: '吉林、辽宁、黑龙江',
    views: 1000,
    likes: 120,
    collections: 50,
    image: CommonConstants.IMAGE_URL_1
  },
  {
    herb_id: 2,
    herb_name: '枸杞',
    category_id: 2,
    pinyin: 'Gou Qi',
    alias: '杞子,红杞',
    property: '甘，平',
    meridian: '归肝、肾经',
    efficacy: '滋补肝肾，益精明目',
    indications: '肝肾阴亏，腰膝酸软，头晕目眩，目昏多泪，虚劳咳嗽，消渴',
    usage: '煎服：6-12g；或入丸、散、膏、酒剂',
    contraindication: '外感热病、正盛者不宜服用',
    production_area: '宁夏、甘肃、青海',
    views: 800,
    likes: 80,
    collections: 30,
    image: CommonConstants.IMAGE_URL_2
  },
  {
    herb_id: 3,
    herb_name: '当归',
    category_id: 3,
    pinyin: 'Dang Gui',
    alias: '秦归,西归',
    property: '甘、辛，温',
    meridian: '归肝、心、脾经',
    efficacy: '补血活血，调经止痛，润肠通便',
    indications: '血虚诸证，月经不调，痛经，经闭，虚寒腹痛，跌打损伤，风湿痹痛，肠燥便秘',
    usage: '煎服：6-12g；或入丸、散',
    contraindication: '湿阻中满及大便溏泄者慎用',
    production_area: '甘肃、四川、云南',
    views: 1200,
    likes: 150,
    collections: 70,
    image: CommonConstants.IMAGE_URL_3
  }
];

@Entry
@Component
struct DetailPage {
  @State herbData: any = null; // 当前中药材数据

  // 页面加载时获取路由参数并查找数据
  aboutToAppear() {
    // 使用 router.getParams() 获取参数
    const params = router.getParams() as { contentId?: number };
    const contentId = params?.contentId;
    console.info('接收到的 contentId:', contentId);

    // 查找对应的中药材数据
    this.herbData = HERB_LIST.find(item => item.herb_id === contentId) || {
      herb_id: 0,
      herb_name: '未知',
      category_id: 0,
      pinyin: '',
      alias: '',
      property: '',
      meridian: '',
      efficacy: '',
      indications: '',
      usage: '',
      contraindication: '',
      production_area: '',
      views: 0,
      likes: 0,
      collections: 0,
      image: CommonConstants.IMAGE_URL_1 // 默认图片
    };
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
      Image(this.herbData?.image || CommonConstants.IMAGE_URL_1)
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