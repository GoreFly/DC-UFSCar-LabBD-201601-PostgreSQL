-- Fun��o com cursor para calcular o total de cr�ditos complementares feitos por um determinado estudante.
CREATE OR REPLACE FUNCTION public.totalcreditoscompl(ra integer)
  RETURNS integer AS
$$
declare
	multiplicador integer;
	carga integer;
	total_creditos integer;
	c1 cursor for select r1.nrosemestres, a.creditos
	from realizaace r1, atcomp a, estudante e
	where r1.estudante_ra = e.ra and
	      r1.atcomp_codigo = a.codigo and
	      e.ra = totalcreditoscompl.ra;
	cur_row RECORD;
begin		
	total_creditos := 0;
	open c1;
	loop
	fetch c1 into cur_row;
	exit when not found;
		multiplicador := cur_row.nrosemestres;
		carga := cur_row.creditos;
		total_creditos := total_creditos + (carga * multiplicador);
	end loop;
	close c1;
	return total_creditos;
end;
$$ language plpgsql;

-- Fun��o com cursor para calcular o total de cr�ditos obrigat�rios feitos por um determinado estudante.
CREATE OR REPLACE FUNCTION totalcreditosobrig(ra integer)
  RETURNS integer AS
$$
declare
	total_creditos integer;
	c1 cursor for select sum(d.nro_creditos)
	from disciplina d, compoe co, cursa cs
	where cs.estudante_ra = totalcreditosobrig.ra and
	      cs.status = 'a' and
	      co.disciplina_codigo = cs.turma_disciplina_codigo and
	      co.obrigatoriedade = true and
	      d.codigo = cs.turma_disciplina_codigo;	      
begin
	open c1;
	fetch c1 into total_creditos;
	close c1;
	return total_creditos;
end;
$$ language plpgsql;

-- Fun��o com cursor para calcular o total de cr�ditos n�o obrigat�rios feitos por um determinado estudante.
CREATE OR REPLACE FUNCTION totalcreditosobrig(ra integer)
  RETURNS integer AS
$$
declare
	total_creditos integer;
	c1 cursor for select sum(d.nro_creditos)
	from disciplina d, compoe co, cursa cs
	where cs.estudante_ra = totalcreditosobrig.ra and
	      cs.status = 'a' and
	      co.disciplina_codigo = cs.turma_disciplina_codigo and
	      co.obrigatoriedade = false and
	      d.codigo = cs.turma_disciplina_codigo;	      
begin
	open c1;
	fetch c1 into total_creditos;
	close c1;
	return total_creditos;
end;
$$ language plpgsql;