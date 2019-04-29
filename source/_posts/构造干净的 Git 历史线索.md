---
title: 构造干净的 Git 历史线索
date: 2016-07-14 19:49:00
tags: CSDN迁移
permalink: construct-cliean-git-history
author:
  nick: 严俊羿
  link: 'https://yanjunyi.com/'
typora-root-url: ../
---

# 构造干净的 Git 历史线索

 用 Git 也有一段时间了，看过一些 Git 工作流的文章，加上工作和业余中参与一些项目开发，对 Git 的工作流有一些心得，写下来整理一下。

 如果你对 Git 并不是很熟悉，推荐两份阅读资料：


  * [ProGit 中文版](http://progit.org/book/zh/) 
  * [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)  本篇文章是基于中心式的代码管理，但如果你理解其内涵，会发现这跟一般的 github 托管的开源项目是兼容的，只要把每个 fork 都当成特性分支，而项目的发源地是中心。


## 理想的历史线索

 首先看一下这个流传很广的图（取自 [A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)）   

 ![A successful Git branching model](/images/20160714192651599)

 这确实是一个理想的版本分支控制流程，至少它有以下优点：


  * 分支成线性 
  * 可追溯某 commit 什么时候被合并进主干  但是，实际中如果不加注意，很容易变成这样：

 ![实际中](/images/20160714192741163)   

 这个历史线索有两个很糟糕的地方：


  * 本来应该只有3个分支：internal，new_bbs，new_blog，但是却有5条线索 
  * 分不清哪条是主干（你能看出吗？上数第3个commit连接的红色的那条才是）  实际上这种情况的发生很普遍，如果你自己在维护一个项目，并且有多人参与开发，可以用 gitg 这个工具打开项目目录看一看。

 下面将会分析图中问题产生的原因和解决方法。


#### 不要产生多余的分支

 留意到上一节的糟糕例子中，有几条 merge 信息是这样的格式：


```
merge <branch> of <source_url> into <branch>
```
 这类 merge 是在开发者向 git 源 push 的时候发生冲突，然后运行git pull的时候产生的。git pull 确实很便利，但是却产生了副作用：一个特性分支变成了两个。


```
git push # 冲突
git pull # ！产生额外的分支
```
 ![这里写图片描述](/images/20160714192859290)

 如果你认为每个 git 源都是平等的，而且每个开发者都是平等的，这没什么问题。不过如果需要一个中心式的开发历史，这些本地分支的合并信息就会成为干扰。

 解决这些多余的 merge 信息的解决方案就是—— rebase。


```
git push # 冲突
git pull --rebase
git push
```
 pull –rebase 可以基于远程分支重写自己的本地 commit，从而产生干净的线索。

 ![这里写图片描述](/images/20160714192927556)

 有人可能会提出异议，pull –rebase 丢失了并行开发的这一信息，没错，这取决于你的项目开发是怎样的管理。如果你跟我一样喜好干净的分支线索，那么同一分支的提交应该用pull –rebase。确实需要保留分支线索的，应该另外开一条分支，而不要pull。

 注意，rebase 某些时候是个危险的工具，因为它实际改写了你的 commit，千万不要 rebase 一些已经提交到公共源的 commit，详情可以看 progit 中 分支的衍合 这一章节。


#### 避免线索“扭麻花”

 依然是这个图

 ![实际中](/images/20160714192741163)

 除了多出的分支外，还有一个严重的问题，就是主干线索（internal）被痛苦的扭到了一边。如果这种情况反复出现，各个线索就会像麻花一样扭在一起。

 现在来重现一下这种扭麻花出现的原因：

 1) 开发者以本地的 master 为基础新建了一个分支 feature A，以此工作，中途更新过 master，然后在工作完成后 merge 回 master 分支。

 ![这里写图片描述](/images/20160714193042620)

 2) 但是向线上的 master push 的时候发生了冲突，因为线上的 master 比自己本地的 master 新。

 ![这里写图片描述](/images/20160714193100683)

 3) 然后，开发者执行了 git pull

 ![这里写图片描述](/images/20160714193120652)

 4) 最后，开发者愉快的 git push ，线上的 master 分支将会和本地一样

 ![这里写图片描述](/images/20160714194147947)

 这样会导致什么问题呢？问题就是如果某个 commit 有 bug，你将无法查证这个 commit 被归入主干分支的上线时间。例如上图的红色色块，看起来是在最新的 merge 之后才进入 master 的，但是它在之前已经进入 master 了。作为 master 分支（甚至任一分支）的管理者，肯定不希望分支的主线索一直在开发者的本地线索中来回切换。

 解决方法是，一定要在 merge 之前，将主干分支更新到最新状态。


```
git checkout master
git pull
git merge feature
git push
```
 如果你事先把 master 更新，线索就会是这样的：

 ![这里写图片描述](/images/20160714193144334)

 bug 点在什么时候进入主干分支一目了然。


#### 线上分支合并一定要用 merge –no-ff

 假设你已经知道，git 中的合并默认是快进合并（fast-forward）

 ![这里写图片描述](/images/20160714194308401)

 线上分支间的快进合并会产生一个问题，就是丢失了合并的时间戳。试问上图的红色有 bug commit 是什么时候进入主分支？

 如果每次分支合并时加上 –no-ff 参数，就可以避免信息的丢失

 ![这里写图片描述](/images/20160714194348498)

 bug 进入主干的时间将很清晰。


## 总结

 假如上面的规则让你感到混乱，那么下面整理两个法则，分别适用于两种身份。

 1.代码提交者身份

 向远程分支提交代码时，先 git pull –rebase，避免把本地状态当作分支提交。

 2.分支管理者身份

 进行线上分支合并时，一律使用 git merge –no-ff，保留合并时间戳。

 不要混用两种身份，一边进行代码提交，一边进行分支合并。这样你的 git 管理将会轻松很多。

 以上转自：[构造干净的 Git 历史线索](http://codecampo.com/topics/379)


## 多人协作规范

 多人合作时比自己管理分支立马复杂了一个数量级，因为每人都会有一套分支结构，如果大家都遵循上一节分支规范还好，否则更加麻烦。

 如果不是一个小团队可以达到内部高度规范和统一，那么大多数时候开源项目更适合使用Pull request的方式合作，这样的方式也更符合GitHub设计的精髓。


#### 分支基点

 Pull request永远使用主仓库的master（或dev，如果有）分支作为base，并新建一个feature-xxx或者fix-xxx分支进行开发，以保证不产生任何额外无关的commit造成合并困难。同时以此小步快跑的方式也能更大程度的保证分支的完整性和延续性，减少难以合并的分支。


#### 推送合并目标

 在发起pull request时，feature部分应对应到主仓库的dev分支，fix部分对应到master分支。


#### 代码评审

 Pull request必须经过主仓库成员code review，并由review人员完成合并。如果自己有主仓库的权限，又通过pull request进行代码分享，那么请不要自己完成合并，否则请直接推送到仓库。


#### 处理期限

 每个pull request的处理期限暂定为14天，超过2周并无人review的request任何有权限的用户（主仓库成员或自己）可以进行关闭，以减少干扰。

 以上转自：[Git使用规范建议](http://mytharcher.github.com/posts/git-suggestions.html)

   
