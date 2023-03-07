function! ale_linters#perl#plls#GetProjectRoot(buffer) abort
    let l:potential_roots = [
    \   'Makefile.PL',
    \   'Build.PL',
    \   'dist.ini',
    \   'MYMETA.yml',
    \   'META.yml',
    \   '.git',
    \   bufname(a:buffer),
    \ ]

    for l:root in l:potential_roots
        let l:project_root = ale#path#FindNearestFile(
        \   a:buffer,
        \   l:root,
        \ )

        if empty(l:project_root)
            let l:project_root = ale#path#FindNearestDirectory(
            \   a:buffer,
            \   l:root,
            \ )
        endif

        if !empty(l:project_root)
            " dir:p expands to /full/path/to/dir/ whereas
            " file:p expands to /full/path/to/file (no trailing slash)
            " Appending '/' ensures that :h:h removes the path's last segment
            " regardless of whether it is a directory or not.
            return fnamemodify(l:project_root . '/', ':p:h:h')
        endif
    endfor

    return ''
endfunction

call ale#Set('perl_plls_config', {})
call ale#linter#Define('perl', {
\   'name': 'plls',
\   'lsp': 'stdio',
\   'executable': {b -> ale#Var(b, 'perl_perl_executable')},
\   'command': '%e -MPerl::LanguageServer -ePerl::LanguageServer::run',
\   'lsp_config': {b -> ale#Var(b, 'perl_plls_config')},
\   'project_root': function('ale_linters#perl#plls#GetProjectRoot'),
\ })
