// pages/Login.ets - 使用 TextInput 组件的登录页面
import router from '@ohos.router';

@Entry
@Component
struct Login {
  @State username: string = '';
  @State password: string = '';
  @State passwordVisible: boolean = false;
  @State isLoading: boolean = false;
  @State errorMessage: string = '';

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
            this.errorMessage = ''; // 清除错误消息
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
            this.errorMessage = ''; // 清除错误消息
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
  handleLogin() {
    // 简单验证
    if (!this.username || !this.password) {
      this.errorMessage = '用户名和密码不能为空';
      return;
    }

    // 显示加载状态
    this.isLoading = true;

    // 模拟登录请求
    setTimeout(() => {
      // 这里应该是实际的登录API调用
      console.info(`尝试登录，用户名: ${this.username}, 密码: ${this.password}`);

      // 模拟登录成功
      if (this.username === 'test' && this.password === '123456') {
        console.info('登录成功');
        // 登录成功后的操作，例如跳转到主页
        router.pushUrl({
          url: 'pages/Main'
        }).catch((err) => {
          console.error(`主页跳转失败: ${err.message}`);
          this.errorMessage = '登录成功，但页面跳转失败';
        });
      } else {
        this.errorMessage = '用户名或密码错误';
      }

      // 重置加载状态
      this.isLoading = false;
    }, 1500);
  }
}