\name{f_weibo_app_followsns}
\alias{f_weibo_app_followsns}
\title{��ע��ϵ�Ŀ��ӻ�}
\usage{
  f_weibo_app_followsns(hisID='chenyibo', sns_df=sns_df, topk=3)
}
\arguments{
  \item{hisID}{�Է���ID�������ļ�����}
  \item{sns_df}{��ע��ϵ�����ݼ�}
  \item{topk}{��עǰtopk���ڵ�}
}
\details{
  ������ɺ󣬻��ڹ���·��������weibo_followsns_hisID_ʱ��.png�ļ�
}
\examples{
load('weibo_saved_snsdf_chenyibo.RData')
f_weibo_app_followsns(hisID='chenyibo', sns_df=sns_df, topk=3)
}
