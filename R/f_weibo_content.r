

# ץȡ���ݣ�Ŀǰֻд��feeds���ֵ�ץȡ��
f_weibo_content <- function(cH=ch0, 
                            N=200, 
                            hisID='chenyibo', 
                            is_e=F){
  # N       ��Ҫ��ȡ��΢������
  # hisID �Է���ID
  # is_e    �Ƿ���ҵ��
  # ���ݲ���ϵͳѡ����ذ�
  pkgs <- installed.packages()[, 1]
  if(!'XML' %in% pkgs){
    install.packages('XML', 
                     repos='http://mirrors.ustc.edu.cn/CRAN/')
  }
  if(!'RCurl' %in% pkgs){
    install.packages('RCurl')
  }
  if(!'RJSONIO' %in% pkgs){
    install.packages('RJSONIO', 
                     repos='http://mirrors.ustc.edu.cn/CRAN/')
  }
  
  sysname <- Sys.info()['sysname']
  if(length(grep('Windows', sysname)) == 1){
    try(memory.limit(4000), silent=T)
    require(RJSONIO)
  } else{
    require(RJSONIO)
  }
  require(RCurl)
  require(XML)
  
  # �ȿ�һ���ж���΢��
  pg <- 1
  the1url <- paste('http://weibo.com/', hisID, '/profile?page=', pg, sep='')
  the1get <- getURL(the1url, curl=cH, .encoding='UTF-8')
  oid <- gsub('^.*\\[\'oid\'\\] = \'([^\']+)\';.*$', '\\1', the1get)
  uid <- gsub('^.*\\[\'uid\'\\] = \'([^\']+)\';.*$', '\\1', the1get)
  if(is_e){
    onick <- gsub('^.*\\[\'onick\'\\] = \"([^\']+)\";.*$', '\\1', the1get)
    number <- gsub('^.*<strong>([0-9]+)</strong><span>΢��.*$', '\\1', the1get)
  } else{
    onick <- gsub('^.*\\[\'onick\'\\] = \'([^\']+)\';.*$', '\\1', the1get)
    number <- gsub('^.*<strong node-type=\\\\"weibo\\\\">([0-9]+)<\\\\/strong>.*$', '\\1', the1get)
  }
  cnt <- min(as.numeric(number), N)
  # pages <- ceiling(min(as.numeric(number), N)/45)
  pages <- 1e+10
  
  weibo_data <- data.frame(weibo_content=NULL, weibo_time=NULL)
  # ѭ����ȡҳ��
  while((nrow(weibo_data) < cnt) & (pg <= pages)){
    # ��һ��
    if(is_e){
      the1url <- paste('http://e.weibo.com/', hisID, '?page=', pg, '&pre_page=', pg-1, sep='')
    } else{
      the1url <- paste('http://weibo.com/', hisID, '/profile?page=', pg, sep='')
    }
    the1get <- getURL(the1url, curl=cH, .encoding='UTF-8')
    # �����˵�ʱ����hisFeed�����Լ���ʱ����myFeed(�����urlҲ���в��죬��Ҫ��ˢ�µ�ʱ����Ҫ�õ�uid)
    myfeed <- paste('^.*<script>STK && STK.pageletM && STK.pageletM.view\\((\\{', 
                    ifelse(uid == oid, '\"pid\":\"pl_content_myFeed\"', '\"pid\":\"pl_content_hisFeed\"'), 
                    '.+?\\})\\)</script>.*$', sep='')
    a1 <- gsub(myfeed, '\\1', the1get)
    a1 <- fromJSON(a1)[['html']]
    # ���һ��΢����ID
    if(length(grep('mid=([0-9]+)', a1)) > 0){
      lastmid <- gsub('^.*mid=([0-9]+).*$', '\\1', a1)
    } else{
      lastmid <- ''
    }
    
    # ���ǵڶ���
    the2url <- paste('http://weibo.com/aj/mblog/mbloglist?', ifelse(is_e, '', '_wv=5&'), 'page=', pg, 
                     '&count=15&max_id=', lastmid, '&pre_page=', pg, '&end_id=&pagebar=0&uid=', oid, sep='')
    the2get <- getURL(the2url, curl=cH, .encoding='UTF-8')
    a2 <- fromJSON(the2get)[['data']]
    # ���һ��΢����ID
    if(length(grep('mid=([0-9]+)', a2)) > 0){
      lastmid <- gsub('^.*mid=([0-9]+).*$', '\\1', a2)
    } else{
      lastmid <- ''
    }
    
    # ���ǵ�����
    the3url <- paste('http://weibo.com/aj/mblog/mbloglist?', ifelse(is_e, '', '_wv=5&'), 'page=', pg, 
                     '&count=15&max_id=', lastmid, '&pre_page=', pg, '&end_id=&pagebar=1&uid=', oid, sep='')
    the3get <- getURL(the3url, curl=cH, .encoding='UTF-8')
    a3 <- fromJSON(the3get)[['data']]
    
    # ɸѡ΢���������ݼ�����ʱ��
    a123 <- htmlParse(c(a1, a2, a3), encoding='UTF-8')
    if(is_e){
      b123 <- getNodeSet(a123, path='//p[@node-type="feed_list_content"]')
    } else{
      b123 <- getNodeSet(a123, path='//div[@node-type="feed_list_content"]')
    }
    c123 <- sapply(b123, xmlValue)
    if(is_e){
      d123 <- getNodeSet(a123, path='//a[@class="date"]')
      did <- which(sapply(d123, function(x){names(xmlAttrs(x))[1]} == 'title'))
      e123 <- sapply(d123[did], function(x){xmlAttrs(x)[['title']]})
    } else{
      d123 <- getNodeSet(a123, path='//a[@class="S_link2 WB_time"]')
      e123 <- sapply(d123, function(x){xmlAttrs(x)[['title']]})
    }
    if(length(c123) == length(e123)){
      weibo_data <- rbind(weibo_data, data.frame(weibo_content=c123, weibo_time=e123, stringsAsFactors=F))
    } else{
      cat('sorry~~~~length of content != length of time', '\n')
    }
    pg <- pg + 1
    f123 <- getNodeSet(a123, path='//a[@action-type="feed_list_page_n"]')
    g123 <- sapply(f123, function(x){xmlAttrs(x)[['action-data']]})
    pages <- max(as.numeric(gsub('page=([0-9]+)', '\\1', g123)))
    weibo_data <- na.exclude(weibo_data)
    weibo_data <- weibo_data[!duplicated(weibo_data), ]
    cat(nrow(weibo_data), '\n')
  }
  cat(hisID, 'actually has', number, 'blogs,\nand we get', nrow(weibo_data), 'of them this time.')
  weibo_content <- list(hisID=hisID, nick=onick, weibo_data=weibo_data)
  save(weibo_content, file=paste('weibo_saved_content_', hisID,'.RData', sep=''))
  return(weibo_content)
}

