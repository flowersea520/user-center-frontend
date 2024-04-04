/**
 * request 网络请求工具
 * 更详细的 api 文档: https://github.com/umijs/umi-request
 */
import {extend} from 'umi-request';
import {message} from "antd";
import {history} from "@@/core/history";
import {stringify} from "querystring";

/**
 * 配置request请求时的默认参数
 */
const request = extend({
  credentials: 'include', // 默认请求是否带上cookie
  /**
   * 关于 'http://user-backend.code-nav.cn' 这个 URL，它通常指的是 后端 服务的地址。在前端开发中，当你需要与后端 API 进行通信时，
   * 你会使用这个 URL 作为请求的基础地址。在这种情况下，如果 NODE_ENV 是 'production'，则你的应用程序将使用这个地址与后端通信；
   * 如果 NODE_ENV 不是 'production'（例如，它可能是 'development'），则前缀将是 undefined，你可能需要在其他地方定义或处理这个值。
   */
  // 这里通过环境变量： 实现根据不同的环境，实现请求不同的地址 (这里可以写自己的域名，也可以写：“http://公网ip:8080”）
  prefix: process.env.NODE_ENV === 'production' ? 'http://39.101.78.159:8080' : undefined,
  // requestType: 'form',
});


/**
 * 所有请求拦截器
 */
request.interceptors.request.use((url, options): any => {
  console.log(`do request url = ${url}`)

  return {
    url,
    options: {
      ...options,
      headers: {},
    },
  };
});

/**
 * 所有响应拦截器
 */
request.interceptors.response.use(async (response, options): Promise<any> => {
  const res = await response.clone().json();
  if (res.code === 0) {
    return res.data;
  }
  if (res.code === 40100) {
    message.error('请先登录');
    history.replace({
      pathname: '/user/login',
      search: stringify({
        redirect: location.pathname,
      }),
    });
  } else {
    message.error(res.description)
  }
  return res.data;
});

export default request;
