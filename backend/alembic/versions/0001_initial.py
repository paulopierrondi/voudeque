"""initial

Revision ID: 0001
Revises: 
Create Date: 2026-05-18 12:00:00

"""
from typing import Sequence, Union
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '0001'
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table('users',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_users_id'), 'users', ['id'], unique=False)

    op.create_table('challenges',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('title', sa.String(), nullable=False),
        sa.Column('description', sa.Text(), nullable=False),
        sa.Column('theme', sa.String(), nullable=False),
        sa.Column('ends_at', sa.DateTime(), nullable=False),
        sa.Column('participants', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_challenges_id'), 'challenges', ['id'], unique=False)

    op.create_table('looks',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('user_id', sa.String(), nullable=False),
        sa.Column('image_url', sa.String(), nullable=True),
        sa.Column('description', sa.Text(), nullable=False),
        sa.Column('occasion', sa.String(), nullable=False),
        sa.Column('votes', sa.Integer(), nullable=True),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['user_id'], ['users.id']),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_looks_id'), 'looks', ['id'], unique=False)

    op.create_table('look_items',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('look_id', sa.String(), nullable=False),
        sa.Column('name', sa.String(), nullable=False),
        sa.Column('category', sa.String(), nullable=False),
        sa.Column('color', sa.String(), nullable=False),
        sa.Column('reason', sa.Text(), nullable=False),
        sa.ForeignKeyConstraint(['look_id'], ['looks.id']),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_look_items_id'), 'look_items', ['id'], unique=False)

    op.create_table('votes',
        sa.Column('id', sa.String(), nullable=False),
        sa.Column('user_id', sa.String(), nullable=False),
        sa.Column('look_id', sa.String(), nullable=False),
        sa.Column('created_at', sa.DateTime(), nullable=True),
        sa.ForeignKeyConstraint(['look_id'], ['looks.id']),
        sa.ForeignKeyConstraint(['user_id'], ['users.id']),
        sa.PrimaryKeyConstraint('id')
    )
    op.create_index(op.f('ix_votes_id'), 'votes', ['id'], unique=False)


def downgrade() -> None:
    op.drop_table('votes')
    op.drop_table('look_items')
    op.drop_table('looks')
    op.drop_table('challenges')
    op.drop_table('users')
