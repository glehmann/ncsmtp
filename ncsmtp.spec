%define name		ncsmtp
%define version		0.1
%define release		1mdk

Name:		%{name}
Summary:	Null Client SMTP daemon with aliases support
Version:	%{version}
Release:	%{release}
URL:		http://voxel.jouy.inra.fr/darcs/ncsmtp
Source0:	ncsmtp-%{version}.tar.bz2
License:	GPL
Group:		System/Servers
Provides:	smtpdaemon, MailTransportAgent
Requires:	python
PreReq:		mini_sendmail
BuildRoot:	%{_tmppath}/%{name}-buildroot

%description
It is a program that replaces sendmail on workstations that
should send their mail via the departmental mailhub from which they pick up
their mail.  This program accepts mail and sends it to the mailhub. It is 
also able to manage aliases, which is useful if administrator of mailhub
and administrator of localhost are not the same person, or if account names
are different on localhost and on mailhub.
As it listen on standard SMPT port by default and is simple to configure,
this program is useful with mini_sendmail in a chroot area, to keep the
default localhost smtp server in lots of programs, and to log mail on
localhost.


%prep
%setup


%build


%install
DESTDIR=%buildroot sh install.sh

%clean
/bin/rm -Rf %buildroot


%files
%defattr(-, root, root, 0755)
%doc COPYING README version
%dir %{_sysconfdir}/ncsmtp
%config(noreplace)  %{_sysconfdir}/ncsmtp/*
%config(noreplace) %{_sysconfdir}/rc.d/init.d/ncsmtp
%{_sbindir}/*


%post
# Install alternatives:
update-alternatives --install %{_sbindir}/sendmail mta %{_sbindir}/mini_sendmail 20

# Install service:
%_post_service ncsmtp


%preun
# Remove service:
%_preun_service ncsmtp

if [ $1 = 0 ]; then
	update-alternatives --remove mta %{_sbindir}/mini_sendmail
fi


%changelog
* Thu Mar 17 2005 Gaetan Lehmann <gaetan.lehmann@jouy.inra.fr> 0.1-1mdk
- initial contrib


