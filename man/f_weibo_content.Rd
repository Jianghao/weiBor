\name{f_weibo_content}
\alias{f_weibo_content}
\title{ץȡ΢������}
\usage{
  f_weibo_content(cH=ch0, N=200, hisID='chenyibo', is_e=F)
}
\arguments{
  \item{cH}{֮ǰ��¼��õ�CurlHandle}
  \item{N}{��Ҫ��ȡ��΢������������}
  \item{hisID}{�Է���ID}
  \item{is_e}{�Ƿ���ҵ��΢��}
}
\value{
  \item{hisID}{�Է���ID}
  \item{nick}{�Է����ǳ�}
  \item{weibo_data}{΢�����ݣ����ݿ������ֶΣ�΢���ı����ݼ�΢������ʱ�䣩}
}
\details{
  ������ɺ󣬻��ڹ���·��������weibo_saved_content_hisID.RData�ļ������ں����������������ݼ�����Ϊweibo_content
}
\examples{
weibo_content1 <- f_weibo_content(cH=ch0, N=100, hisnick='chenyibo', is_e=F)
head(weibo_content1$weibo_data)

weibo_content2 <- f_weibo_content(cH=ch0, N=100, hisnick='eeocomcn', is_e=T)
head(weibo_content2$weibo_data)
}
