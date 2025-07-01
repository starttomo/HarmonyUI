import router from '@ohos.router';
import { CommonConstants } from '../constants/CommonConstants';
import  AppStorage  from '@ohos.app.ability.common';

// 底部导航栏组件
@Component
export struct BottomTabs {
  @State selectedIndex: number = 0; // 当前选中的导航索引
  // 页面路由列表
  private routes = [
    'pages/Index',
    'pages/VideoPage',
    'pages/StudyPage',
    'pages/ProfilePage'
  ];
  // 页面名称列表，用于匹配
  private pageNames = [
    'Index',
    'VideoPage',
    'StudyPage',
    'ProfilePage'
  ];

  // 页面加载时初始化选中状态
  aboutToAppear() {
    this.syncSelectedIndexWithRoute();
  }

  // 页面显示时同步选中状态
  onPageShow() {
    this.syncSelectedIndexWithRoute();
  }

  // 同步当前路由与选中索引
  private syncSelectedIndexWithRoute() {
    // 获取当前路由状态
    const state = router.getState();
    let currentRoute = state?.name || state?.path || '';

    // 打印完整路由状态以调试
    console.info('路由状态:', JSON.stringify(state));

    // 规范化路由路径（移除查询参数和首尾斜杠）
    if (currentRoute) {
      currentRoute = currentRoute.split('?')[0].replace(/^\/+|\/+$/g, '');
    }

    console.info('当前路由:', currentRoute);

    // 优先从 AppStorage 获取索引
    const storedIndex = AppStorage.Get<number>('selectedTabIndex') || 0;
    if (storedIndex >= 0 && storedIndex < this.routes.length && storedIndex !== this.selectedIndex) {
      console.info('从 AppStorage 设置选中索引:', storedIndex);
      this.selectedIndex = storedIndex;
      return;
    }

    // 提取页面名称
    const pageName = currentRoute.split('/').pop() || currentRoute;

    // 查找匹配的路由索引
    const index = this.pageNames.findIndex(name => {
      return pageName === name || currentRoute.includes(name);
    });

    // 如果找到匹配的路由，更新选中索引
    if (index !== -1 && index !== this.selectedIndex) {
      console.info('通过路由匹配更新选中索引为:', index);
      this.selectedIndex = index;
      AppStorage.SetOrCreate('selectedTabIndex', index); // 保存到 AppStorage
    } else if (index === -1) {
      console.warn('未找到匹配的路由:', currentRoute);
      // 不重置 selectedIndex，保留上次点击的状态
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.selectedIndex }) {
      // 首页
      TabContent() {
      }.tabBar({
        icon: CommonConstants.HOME_ICON,
        text: '首页',
        textColor: this.selectedIndex === 0 ? '#007AFF' : '#666666'
      })

      // 视频页面
      TabContent() {
      }.tabBar({
        icon: CommonConstants.VIDEO_ICON,
        text: '视频',
        textColor: this.selectedIndex === 1 ? '#007AFF' : '#666666' // 修复格式错误
      })

      // 每日一学页面
      TabContent() {
      }.tabBar({
        icon: CommonConstants.STUDY_ICON,
        text: '每日一学',
        textColor: this.selectedIndex === 2 ? '#007AFF' : '#666666'
      })

      // 个人中心页面
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
      // 点击导航栏时跳转页面
      if (index < this.routes.length && index !== this.selectedIndex) {
        console.info('导航到页面:', this.routes[index]);
        this.selectedIndex = index; // 先更新 UI 状态
        AppStorage.SetOrCreate('selectedTabIndex', index); // 保存到 AppStorage
        router.pushUrl({
          url: this.routes[index],
          params: { from: 'tabs' }
        }).then(() => {
          console.info('导航成功，当前索引:', index);
        }).catch(err => {
          console.error('导航失败:', JSON.stringify(err));
          this.syncSelectedIndexWithRoute(); // 导航失败时同步状态
        });
      }
    })
  }
}