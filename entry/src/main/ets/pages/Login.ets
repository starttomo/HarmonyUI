// Login.ets
import router from '@ohos.router';
import preferences from '@ohos.data.preferences';
import { loginUser } from '../utils/UserData';
@Entry
@Component
struct Login {
  @State username: string = '';
  @State password: string = '';
  @State passwordVisible: boolean = false;
  @State isLoading: boolean = false;
  @State errorMessage: string = '';

  // 存储 token、user_id 到 Preferences
  private async setLoginInfo(token: string, userId: number) {
    try {
      const context = getContext(this); // Ensure context is obtained correctly
      const pref = await preferences.getPreferences(context, 'user_token');
      await pref.put('token', token);
      await pref.put('username', this.username); // Store username for ProfilePage
      await pref.put('user_id', userId); // 新增
      await pref.flush();
      console.info('Token 和 user_id 保存成功');
    } catch (err) {
      console.error('Token 保存失败:', err);
      this.errorMessage = '系统错误，请稍后再试';
    }
  }

  build() {
    Column() {
      // 标题
      Text('HELLO！')
        .fontSize(64)
        .fontColor('#008000')
        .margin({ top: 20, bottom: 50, left: 50 })

      // 错误消息提示
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor('#FF0000')
          .margin({ bottom: 20 })
      }

      // 用户名输入
      Column() {
        Text('用户名')
          .fontSize(18)
          .margin({ bottom: 5 })

        TextInput({
          text: this.username,
          placeholder: '请输入用户名'
        })
          .onChange((value: string) => {
            this.username = value;
            this.errorMessage = '';
          })
          .type(InputType.Normal)
          .width('100%')
          .height(50)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 20 })
      }
      .width('80%')

      // 密码输入
      Column() {
        Text('密码')
          .fontSize(18)
          .margin({ bottom: 5 })

        TextInput({
          text: this.password,
          placeholder: '请输入密码'
        })
          .onChange((value: string) => {
            this.password = value;
            this.errorMessage = '';
          })
          .type(this.passwordVisible ? InputType.Normal : InputType.Password)
          .width('100%')
          .height(50)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .margin({ bottom: 10 })

        // 密码可见性切换
        Row() {
          Checkbox()
            .select(this.passwordVisible)
            .onChange((isChecked: boolean) => {
              this.passwordVisible = isChecked;
            })
            .width(24)
            .height(24)

          Text('显示密码')
            .fontSize(14)
            .margin({ left: 5 })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
        .margin({ bottom: 50 })
      }
      .width('80%')

      // 按钮区域
      Row() {
        Button(this.isLoading ? '登录中...' : '登录')
          .onClick(() => {
            this.handleLogin();
          })
          .width(150)
          .height(50)
          .margin({ right: 20 })
          .enabled(!this.isLoading)

        Button('注册')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Register'
            }).catch((err) => {
              console.error(`注册页面跳转失败: ${err.message}`);
              this.errorMessage = '页面跳转失败，请稍后再试';
            });
          })
          .width(150)
          .height(50)
      }
      .width('80%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  // 处理登录逻辑
  private async handleLogin() {
    // 验证输入
    if (!this.username.trim()) {
      this.errorMessage = '请输入用户名';
      return;
    }

    if (!this.password.trim()) {
      this.errorMessage = '请输入密码';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    try {
      // 调用登录函数
      const res = await loginUser(this.username, this.password);

      if (res && res.token && res.user && res.user.user_id) {
        // 存储 token 和 user_id
        await this.setLoginInfo(res.token, res.user.user_id);

        // 跳转到 ProfilePage 页面
        await router.replaceUrl({ url: 'pages/ProfilePage' });
      } else {
        this.errorMessage = '登录失败，请检查用户名和密码';
      }
    } catch (err) {
      console.error('登录错误:', err);
      this.errorMessage = '登录失败，请稍后再试';
    } finally {
      this.isLoading = false;
    }
  }
}