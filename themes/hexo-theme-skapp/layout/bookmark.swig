{% extends '_layout.swig' %}

{% block pageCss %}
    {{ css('scss/views/page/about') }}
{% endblock %}

{% block main %}
    {% include './_partial/bookmark/main.swig' %}
{% endblock %}

{% block other %}
    {% include './_partial/common/comment.swig' %}
{% endblock %}