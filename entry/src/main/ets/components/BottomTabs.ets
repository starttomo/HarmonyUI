// components/BottomTabs.ets
import router from '@ohos.router';
import { CommonConstants } from '../constants/CommonConstants';
import common from '@ohos.app.ability.common';
@Component
export struct BottomTabs {
  @State selectedIndex: number = 0;
  private routes = [
    'pages/Index',
    'pages/VideoPage',
    'pages/StudyPage',
    'pages/ProfilePage'
  ];
  aboutToAppear() {
    this.syncSelectedIndexWithRoute();
    // 使用页面显示/隐藏事件来监听路由变化
    // 或者使用全局事件总线（如果有）
  }

  onPageShow() {
    // 每次页面显示时同步状态
    this.syncSelectedIndexWithRoute();
  }

  syncSelectedIndexWithRoute() {
    const currentRoute = router.getState()?.path;
    const routes = [
      'pages/Index',
      'pages/VideoPage',
      'pages/StudyPage',
      'pages/ProfilePage'
    ];
    const index = routes.findIndex(route => route === currentRoute);
    if (index !== -1 && index !== this.selectedIndex) {
      this.selectedIndex = index;
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.selectedIndex }) {
      TabContent() {
      }.tabBar({
        icon: CommonConstants.HOME_ICON,
        text: '首页',
        textColor: this.selectedIndex === 0 ? '#007AFF' : '#666666'
      })

      TabContent() {
      }.tabBar({
        icon: CommonConstants.VIDEO_ICON,
        text: '视频',
        textColor: this.selectedIndex === 1 ? '#007AFF' : '#666666'
      })

      TabContent() {
      }.tabBar({
        icon: CommonConstants.STUDY_ICON,
        text: '每日一学',
        textColor: this.selectedIndex === 2 ? '#007AFF' : '#666666'
      })

      TabContent() {
      }.tabBar({
        icon: CommonConstants.PROFILE_ICON,
        text: '我的',
        textColor: this.selectedIndex === 3 ? '#007AFF' : '#666666'
      })
    }
    .barMode(BarMode.Fixed)
    .width('100%')
    .height(60)
    .onChange((index: number) => {
      // const routes = [
      //   'pages/Index',
      //   'pages/VideoPage',
      //   'pages/StudyPage',
      //   'pages/ProfilePage'
      // ];

      if (index < this.routes.length) {
        this.selectedIndex = index; // 先更新UI状态
        router.pushUrl({
          url: this. routes[index],
          params: { from: 'tabs' }
        }).catch(err => {
          console.error(`导航失败: ${err.message}`);
          this.syncSelectedIndexWithRoute(); // 失败时恢复状态
        });
      }
    })
  }
}